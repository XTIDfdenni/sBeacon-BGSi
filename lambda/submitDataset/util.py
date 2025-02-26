from concurrent.futures import ThreadPoolExecutor, as_completed
from typing import Set

from shared.utils import get_vcf_chromosomes, get_vcf_samples


def get_vcf_chromosome_map(vcf_location):
    errored, error, chroms = get_vcf_chromosomes(vcf_location)
    vcf_chromosome_map = None
    if not errored:
        vcf_chromosome_map = {"vcf": vcf_location, "chromosomes": chroms}

    return errored, error, vcf_chromosome_map


def get_vcf_chromosome_maps(vcf_locations):
    executor = ThreadPoolExecutor(32)
    errored = False
    errors = []
    vcf_chromosome_maps = []
    vcf_chromosome_map_futures = [
        executor.submit(get_vcf_chromosome_map, vcf_location)
        for vcf_location in set(vcf_locations)
    ]

    for vcf_chromosome_map_future in as_completed(vcf_chromosome_map_futures):
        (
            task_errored,
            error,
            vcf_chromosome_map,
        ) = vcf_chromosome_map_future.result()
        errored = errored or task_errored
        errors.append(error)
        vcf_chromosome_maps.append(vcf_chromosome_map)

    return errored, errors, vcf_chromosome_maps


def get_vcfs_samples(vcfs) -> Set[str]:
    errored = False
    errors = []
    vcfs_samples = set()
    vcf_samples_futures = [
        ThreadPoolExecutor().submit(get_vcf_samples, vcf) for vcf in vcfs
    ]
    for vcf_samples_future in vcf_samples_futures:
        task_errored, error, samples = vcf_samples_future.result()
        errored = errored or task_errored
        errors.append(error)
        vcfs_samples.update(samples)
    return errored, errors, vcfs_samples
