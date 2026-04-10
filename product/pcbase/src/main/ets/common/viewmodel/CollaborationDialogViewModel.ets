/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { PageDesktopViewModel } from '@ohos/pagedesktop/src/main/ets/default/common/viewmodel/PageDesktopViewModel';
import fileFolderManagerFactory from '@ohos/desktopfilefolder/src/main/ets/default/manager/FileFolderManagerFactory';
import FileFolderManager from '@ohos/desktopfilefolder/src/main/ets/default/manager/FileFolderManager';
import { LogDomain, LogHelper, SingleContext } from '@ohos/basicutils';
import { HiSysEventUtil, ResourceManager } from '@ohos/frameworkwrapper';
import { DisplayConstants } from '@ohos/windowscene';
import PcFileAccess from '../controller/PcFileAccess'
import fs from '@ohos.file.fs';
import { DragGridPosition } from '@ohos/componentdrag';
import { Prompt } from '@kit.ArkUI';
import { util } from '@kit.ArkTS';
import { systemDateTime, BusinessError } from '@kit.BasicServicesKit';

const TAG = 'CollaborationDialogViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const FILE_NAMES = 1001202006;
const FINISHED = 1001202005;


export class CollaborationDialogViewModel {
  private singleContext?: SingleContext;
  private mPageDesktopViewModel: PageDesktopViewModel;
  private fileFolderManager: FileFolderManager = fileFolderManagerFactory.getFileFolderManager();
  private rightClickPosition: DragGridPosition = {column: 0, row: 0};
  private fileNameList: string[] = [];
  private fileIdx: number = 0;

  constructor(ctx?: SingleContext) {
    this.singleContext = ctx;
    this.mPageDesktopViewModel = PageDesktopViewModel.getInstance(this.singleContext);
  }

  isDeskTopAvailable(): boolean {
    if (!this.mPageDesktopViewModel.isCanCreateFolder()) {
      HiSysEventUtil.reportFullContinueAdding(DisplayConstants.DEFAULT_DISPLAY);
      Prompt.showToast({
        message: ResourceManager.getInstance().getStringByName('add_icon_to_desktop_max')
      });
      log.showError('onStateProcess add icon to desktop max');
      return false;
    }
    return true;
  }

  upDateDeskTop(dirUri: string, newFilePosition: DragGridPosition) {
    let uris: Map<string, number[]> = new Map<string, number[]>();
    let colAndRow: number[] = [];
    colAndRow[0] = newFilePosition.column;
    colAndRow[1] = newFilePosition.row;
    log.showInfo(`onStateProcess column: ${colAndRow[0]}, row: ${colAndRow[1]}`);
    uris.set(dirUri, colAndRow);
    this.fileFolderManager.createNewFile(uris);
    this.fileFolderManager.refreshDesktopFiles();
    log.showInfo('onStateProcess create file end');
  }

  imageProcess(buffer?: ArrayBuffer) {
    if (!this.isDeskTopAvailable()) {
      return;
    }
    let newFilePosition: DragGridPosition | undefined =
      this.mPageDesktopViewModel.getNewFilePosition(this.rightClickPosition.column, this.rightClickPosition.row);
    if (!newFilePosition) {
      log.showError('onStateProcess getNewFilePosition failed');
      return;
    }
    let dirUri = this.buildNewFile(buffer);
    if (dirUri === '') {
      log.showError('buildNewFile failed');
      return;
    }
    this.upDateDeskTop(dirUri, newFilePosition);
  }

  fileNameProcess(buffer?: ArrayBuffer) {
    try {
      let decoder = util.TextDecoder.create('utf-8');
      let fileNameStr = decoder.decodeWithStream(new Uint8Array(buffer));
      this.fileNameList = JSON.parse(fileNameStr);
      this.fileIdx = 0;
      log.showInfo('onStateProcess get fileName num: ' + this.fileNameList.length);
    } catch (err) {
      log.showError('onStateProcess error:' + err?.code + ', ' + err?.message);
      this.fileNameList = [];
      this.fileIdx = 0;
    }
  }

  public onStateProcess(stateCode: number, dataType?: string, buffer?: ArrayBuffer): void {
    log.showInfo('onStateProcess stateCode is ' + stateCode);
    switch (stateCode) {
      case 0: {
        this.imageProcess(buffer);
        break;
      }
      case FILE_NAMES: {
        this.fileNameProcess(buffer);
        break;
      }
      case FINISHED: {
        this.fileIdx = 0;
        this.fileNameList = [];
        break;
      }
      default: {
        break;
      }
    }
  }

  buildNewFile(buffer?: ArrayBuffer): string {
    const uri: string = PcFileAccess.desktopPath;
    if (!uri) {
      log.showError('buildNewFile invalid deskTopUri');
      return '';
    }
    const buildFileName: string = this.getFileName(uri);
    if (buildFileName === '') {
      return '';
    }
    // const filePath: string = `${FileUtil.getPathFromUri(uri)}/${buildFileName}`;
    const filePath: string = `${buildFileName}`;
    try {
      log.showInfo(`buildNewFile create file[${this.fileIdx}]`);
      let createRes: fs.File = fs.openSync(filePath, fs.OpenMode.WRITE_ONLY | fs.OpenMode.CREATE);
      // FsUtil.writeSync(createRes.fd, buffer);
      // FsUtil.closeSync(createRes);
    } catch (err) {
      log.showError('file process error:' + err?.code + ', ' + err?.message);
      return '';
    }
    this.fileIdx++;
    // const fileUri: string = FileUtil.getUriFromPath(filePath);
    const fileUri: string = '';
    // RecentUtil.addRecentFile(fileUri, true);

    /*let historyInfo = HistoryData.getHistoryInfoByFileInfos(FileOperationType.CREATE_NEW, [],
      HistoryData.getFileInfosByEasyInfos([FileInfo.fromFileUri(fileUri)]));
    OperatorHistoryModel.addHistory(historyInfo);*/
    return fileUri;
  }

  getFileName(uri: string): string {
    let rawFileName: string = this.getDefaultName();
    if (this.fileIdx < this.fileNameList.length) {
      rawFileName = this.fileNameList[this.fileIdx];
    }
    let buildFileName: string = '';
    const filePre: string = rawFileName.substring(0, rawFileName.lastIndexOf('.'));
    const fileExt: string = rawFileName.substring(rawFileName.lastIndexOf('.'));
    let getFileNameExt: Function = (n: number): void => {
      if (n <= 1) {
        buildFileName = `${filePre}${fileExt}`;
      } else {
        buildFileName = `${filePre}_${n}${fileExt}`;
      }
    };
    // let parentPath = FileUtil.getPathFromUri(uri);
    let parentPath = '';
    let num = 0;
    let res: BusinessError | boolean = false;
    do {
      num++;
      getFileNameExt(num);
      /*res = FsUtil.accessSync(parentPath + '/' + buildFileName);
      if (res instanceof Error) {
        log.showError(`getFileName error, message: ${res.message}`);
        return '';
      }*/
    } while (res);
    log.showInfo('getFileName success');
    return buildFileName;
  }

  getDefaultName(): string {
    let defaultName: string = '';
    let time = systemDateTime.getTime(false);
    let date = new Date(time);
    const year = date.getFullYear();
    const month = ('0' + (date.getMonth() + 1)).slice(-2);
    const day = ('0' + date.getDate()).slice(-2);
    const hours = ('0' + date.getHours()).slice(-2);
    const minutes = ('0' + date.getMinutes()).slice(-2);
    const seconds = ('0' + date.getSeconds()).slice(-2);
    const millSeconds = ('0' + date.getMilliseconds()).slice(-2);
    defaultName = `IMG_${year}${month}${day}_${hours}${minutes}${seconds}${millSeconds}.jpg`;
    return defaultName;
  }
}