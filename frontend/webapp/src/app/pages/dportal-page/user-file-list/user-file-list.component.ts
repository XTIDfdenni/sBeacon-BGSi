import { Component, OnInit } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { catchError, of } from 'rxjs';
import { DportalService } from 'src/app/services/dportal.service';
import { Storage } from 'aws-amplify';
import { ClipboardModule } from '@angular/cdk/clipboard';

@Component({
  selector: 'app-user-file-list',
  standalone: true,
  imports: [MatButtonModule, MatIconModule],
  templateUrl: './user-file-list.component.html',
  styleUrl: './user-file-list.component.scss',
})
export class UserFileListComponent implements OnInit {
  myFiles: any[] = [];
  constructor(private dps: DportalService) {}

  ngOnInit(): void {
    this.list();
  }

  async list() {
    const res = await Storage.list(`saved-queries/`, {
      pageSize: 'ALL',
      level: 'private',
    });
    this.myFiles = res.results;
  }

  async copy(file: any) {
    const url = await Storage.get(file.key, {
      expires: 3600,
      level: 'private',
    });
    navigator.clipboard
      .writeText(url)
      .then(() => {
        console.log('URL copied to clipboard');
      })
      .catch((err) => {
        console.error('Could not copy URL: ', err);
      });
  }

  async delete(file: any) {
    await Storage.remove(file.key, { level: 'private' });
    this.myFiles = this.myFiles.filter((f) => f.key !== file.key);
  }
}