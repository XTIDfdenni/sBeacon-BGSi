import json
import os

from utils.router import LambdaRouter, PortalError
from utils.models import Projects, ProjectUsers
from utils.s3_util import list_s3_prefix, delete_s3_objects
from utils.cognito import get_user_from_attribute, get_user_attribute
from pynamodb.exceptions import DoesNotExist

router = LambdaRouter()
DPORTAL_BUCKET = os.environ.get("DPORTAL_BUCKET")


#
# Project User Functions
#


@router.attach("/dportal/admin/projects/{name}/users", "get")
def list_project_users(event, context):
    name = event["pathParameters"]["name"]

    try:
        Projects.get(name)
    except DoesNotExist:
        raise PortalError(404, "Project not found")

    user_projects = ProjectUsers.query(name)
    users = [
        get_user_from_attribute("sub", user_project.uid)
        for user_project in user_projects
    ]
    users = [
        {
            "firstName": get_user_attribute(user, "given_name"),
            "lastName": get_user_attribute(user, "family_name"),
            "email": get_user_attribute(user, "email"),
        }
        for user in users
    ]

    return users


@router.attach("/dportal/admin/projects/{name}/users/{email}", "delete")
def remove_project_user(event, context):
    name = event["pathParameters"]["name"]
    email = event["pathParameters"]["email"]
    user = get_user_from_attribute("email", email)
    uid = get_user_attribute(user, "sub")

    try:
        ProjectUsers(name, uid).delete()
    except DoesNotExist:
        raise PortalError(409, "Unable to delete")

    return {"success": True}


@router.attach("/dportal/admin/projects/{name}/users", "post")
def add_user_to_project(event, context):
    name = event["pathParameters"]["name"]
    body_dict = json.loads(event.get("body"))
    emails = body_dict.get("emails")
    users = [get_user_from_attribute("email", email) for email in emails]

    try:
        Projects.get(name)
    except DoesNotExist:
        raise PortalError(404, "Project not found")

    with ProjectUsers.batch_write() as batch:
        for user in users:
            user_id = get_user_attribute(user, "sub")
            user_project = ProjectUsers(name, user_id)
            batch.save(user_project)

    return {"success": True}


#
# Project Functions
#


@router.attach("/dportal/admin/projects/{name}", "delete")
def delete_project(event, context):
    name = event["pathParameters"]["name"]

    try:
        project = Projects.get(name)
    except DoesNotExist:
        raise PortalError(404, "Project not found")

    keys = list_s3_prefix(DPORTAL_BUCKET, f"projects/{project.name}/")
    delete_s3_objects(DPORTAL_BUCKET, keys)

    with ProjectUsers.batch_write() as batch:
        for entry in ProjectUsers.scan():
            batch.delete(entry)

    project.delete()

    return {"success": True}


@router.attach("/dportal/admin/projects/{name}", "put")
def update_project(event, context):
    name = event.get("path").get("name")
    body_dict = json.loads(event.get("body"))
    description = body_dict.get("description")
    files = body_dict.get("files")
    project = Projects.get(name)
    project.description = description
    project.files = files
    project.save()

    return project.to_dict()


@router.attach("/dportal/admin/projects", "post")
def create_project(event, context):
    body_dict = json.loads(event.get("body"))
    name = body_dict.get("name")
    description = body_dict.get("description")
    files = body_dict.get("files")

    if Projects.count(name):
        raise PortalError(409, "Project already exists")

    # TODO tag s3 objects with project name
    # add a life cycle policy to delete objects unless tagged to avoid
    # zombie projects

    project = Projects(
        name,
        description=description,
        files=files,
    )
    project.save()

    return project.to_dict()


@router.attach("/dportal/admin/projects", "get")
def list_projects(event, context):
    projects = Projects.scan()
    return [project.to_dict() for project in projects]
