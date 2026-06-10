/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { LogDomain, LogHelper } from '@ohos/basicutils';
// import { systemShare } from '@kit.ShareKit';
// import { harmonyShare } from './interface';
import { uniformTypeDescriptor } from '@kit.ArkData';
import { CommonConstants, EventConstants, FileType, GridLayoutItemInfo } from '@ohos/launchercommon';
import PcFileAccess from '../../common/controller/PcFileAccess';
import { PageDesktopViewModel } from '@ohos/pagedesktop';
import { fileFolderManagerFactory } from '@ohos/desktopfilefolder/index'
import { localEventManager } from '@ohos/frameworkwrapper';

const TAG = 'KnockShare';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const KNOCK_SHARE = 'knockShare';
const KNOCK_RECEIVE = 'dataReceive';
const RECV_CAPABILITY_UTD_TYPE = 'harmonyshare.generaltype';
const TYPE_FILE_FOLDER = 0;

export class KnockShare {
  private windowID: number;
  private getKnockShareData: Callback<void, KnockShareData> = () => new KnockShareData();
  // private knockReceiveCallback: KnockReceiveCallback | undefined = undefined;

  constructor(windowID: number) {
    this.windowID = windowID;
  }

  // private shareCallback: Callback<harmonyShare.SharableTarget> = (sharableTarget: harmonyShare.SharableTarget) => {
  //   log.showInfo('share callback');
  //   const knockShareData: KnockShareData = this.getKnockShareData();
  //   if (knockShareData.isError()) {
  //     log.showInfo(`error reject, error code:${knockShareData.getErrorCode()}`);
  //     sharableTarget.reject(knockShareData.getErrorCode() as number);
  //     return;
  //   }
  //   const shareData: ESObject | undefined = knockShareData.getShareData();
  //   if (!shareData) {
  //     log.showInfo('shareCallback, no data need to share');
  //     sharableTarget.reject(ShareErrorCode.NO_SHARE_DATA as number);
  //     return;
  //   }
  //   log.showInfo(`share data length:${shareData.getRecords().length}`);
  //   sharableTarget.share(shareData);
  // }
  //
  // private receiveCallback: Callback<harmonyShare.ReceivableTarget> =
  //   (receivableTarget: harmonyShare.ReceivableTarget) => {
  //   const receivePath: string = this.knockReceiveCallback?.getReceivePath() ?? '';
  //   log.showInfo(`receiveCallback:${!!receivePath}`);
  //     if (!this.knockReceiveCallback) {
  //       log.showWarn('knockReceiveCallback is null');
  //       return;
  //     }
  //   receivableTarget.receive(receivePath, this.knockReceiveCallback);
  // }

  public registerKnockShare(getShareDataCallback: Callback<void, KnockShareData>): void {
    this.getKnockShareData = getShareDataCallback;
    // harmonyShare.on(KNOCK_SHARE, { windowId: this.windowID }, this.shareCallback);
  }

  public unregisterKnockShare(): void {
    this.getKnockShareData = () => new KnockShareData();
    // harmonyShare.off(KNOCK_SHARE, { windowId: this.windowID }, this.shareCallback);
  }

  // public registerKnockReceive(knockReceiveCallback: KnockReceiveCallback): void {
  //   this.knockReceiveCallback = knockReceiveCallback;
  //   const recvCapability = new KnockRecvCapability(RECV_CAPABILITY_UTD_TYPE, 100000);
  //   const recvCapabilityRegistry = new KnockRecvCapabilityRegistry(this.windowID, [recvCapability]);
  //   // harmonyShare.on(KNOCK_RECEIVE, recvCapabilityRegistry, this.receiveCallback);
  // }
  //
  // public unregisterKnockReceive(): void {
  //   this.knockReceiveCallback = undefined;
  //   const recvCapability = new KnockRecvCapability(RECV_CAPABILITY_UTD_TYPE, 100000);
  //   const recvCapabilityRegistry = new KnockRecvCapabilityRegistry(this.windowID, [recvCapability]);
  //   // harmonyShare.off(KNOCK_RECEIVE, recvCapabilityRegistry, this.receiveCallback);
  // }
}

// export class KnockRecvCapability implements harmonyShare.RecvCapability {
//   public utd: string;
//   public maxSupportedCount: number;
//
//   constructor(utd: string, maxSupportedCount: number) {
//     this.utd = utd;
//     this.maxSupportedCount = maxSupportedCount;
//   }
// }
//
// export class KnockRecvCapabilityRegistry implements harmonyShare.RecvCapabilityRegistry {
//   public windowId: number;
//   public capabilities: harmonyShare.RecvCapability[];
//
//   constructor(windowID: number, capabilities: harmonyShare.RecvCapability[]) {
//     this.windowId = windowID;
//     this.capabilities = capabilities;
//   }
// }

export class KnockShareRecord implements ESObject {
  public utd: string;
  public content: string | undefined;
  public uri: string | undefined;
  public title: string | undefined;
  public label: string | undefined;
  public description: string | undefined;
  public thumbnail: Uint8Array | undefined;
  public thumbnailUri: string | undefined;
  public extraData: Record<string, string | number | boolean | (string | number | boolean)[]> | undefined;

  constructor(utd: string) {
    this.utd = utd;
  }
}

// export class KnockReceiveCallback implements harmonyShare.ReceiveCallback {
//   private receivePath: string;
//   private knockShareController: KnockShareController;
//
//   constructor(knockShareController: KnockShareController, receivePath: string) {
//     this.knockShareController = knockShareController;
//     this.receivePath = receivePath;
//   }
//
//   public getReceivePath(): string {
//     return this.receivePath;
//   }
//
//   public onDataReceived: Callback<ESObject> = (shareData: ESObject) => {
//     log.showInfo(`receive finish, data length:${shareData.getRecords().length}`);
//     this.knockShareController.dealWithReceiveData(shareData.getRecords(), this.receivePath);
//   };
// }

export enum ShareErrorCode {
  NO_ERROR = -1,
  NO_SHARE_DATA = 4,
  NO_SUPPORT_DATA = 5
}

export class KnockShareData {
  private shareData: ESObject | undefined;
  private errorCode: ShareErrorCode = ShareErrorCode.NO_ERROR;

  public addRecord(record: ESObject): void {
    if (this.shareData === undefined) {
      // this.shareData = new systemShare.SharedData(record);
    } else {
      this.shareData.addRecord(record);
    }
  }

  public reportError(errorCode: number): void {
    this.errorCode = errorCode;
  }

  public isError(): boolean {
    return this.errorCode !== ShareErrorCode.NO_ERROR;
  }

  public getErrorCode(): ShareErrorCode {
    return this.errorCode;
  }

  public getRecords(): ESObject[] {
    return this.shareData?.getRecords() ?? [];
  }

  public getShareData(): ESObject | undefined {
    return this.shareData;
  }
}

export class KnockShareController {

  /**
   * 处理云水桥分享的数据，接收路径中单个文件直接打开，文件夹或多个文件高亮显示
   * eg:
   * input: file                   output: open file
   * input: folder                 output: highlight folder
   * input: [file, folder]         output: highlight [file, folder]
   * @param records 云水桥分享的数据记录
   * @param receivePath 分享数据的落盘路径
   */
  public dealWithReceiveData(records: ESObject[], receivePath: string): void {
    if (!records || records.length <= 0) {
      log.showWarn('receive data is null');
      return;
    }
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_RESET_ALL_SELECT_STATUS, null);
    if (records.length === 1 && this.isFileInReceivePath(records[0], receivePath)) {
      fileFolderManagerFactory.getFileFolderManager().openFileOrFolder(records[0].uri ?? '');
      return;
    }
    this.highlightFileFolder(this.getFileFoldersUri(records, receivePath));
  }

  /**
   * 获取在接收路径中的uri，文件夹下的子文件（夹）取文件夹uri，即接收路径下一级元素的uri
   * eg:
   * input: desktop/file                              output: desktop/file
   * input: desktop/folder/file                       output: desktop/folder
   * input: desktop/folder0/folder1/folder.../file    output: desktop/folder0
   * @param uri 文件（夹）uri
   * @param receivePath 接收路径
   * @returns 在接收路径中的uri
   */
  private getUriInReceivePath(uri: string | undefined, receivePath: string): string {
    if (!uri || uri.substring(0, receivePath.length) !== receivePath) {
      log.showError(`getUriInReceivePath, not in receivePath, ${!!uri}, ${!!receivePath}`);
      return '';
    }
    const relativeUriArr = uri.substring(receivePath.length).split('/');
    if (relativeUriArr.length < 2) {
      log.showWarn('getUriInReceivePath, uri error');
      return '';
    }
    return receivePath + '/' + relativeUriArr[1];
  }

  private isFileInReceivePath(record: ESObject, receivePath: string): boolean {
    const uriInReceivePath = this.getUriInReceivePath(record.uri, receivePath);
    const fileFolderInfo = fileFolderManagerFactory.getFileFolderManager().getFileInfoByUri(uriInReceivePath);
    if (!fileFolderInfo) {
      log.showWarn('isFileInReceivePath, fileFolderInfo is null');
      return false;
    }
    return fileFolderInfo.fileType === FileType.TYPE_FILE;
  }

  private isFolderInReceivePath(record: ESObject, receivePath: string): boolean {
    const uriInReceivePath = this.getUriInReceivePath(record.uri, receivePath);
    const fileFolderInfo = fileFolderManagerFactory.getFileFolderManager().getFileInfoByUri(uriInReceivePath);
    if (!fileFolderInfo) {
      log.showWarn('isFolderInReceivePath, fileFolderInfo is null');
      return false;
    }
    return fileFolderInfo.fileType === FileType.TYPE_FOLDER;
  }

  /**
   * 获取接收路径中的文件（夹）的uri，接收路径中文件夹下的子文件(夹) 记录其父文件夹的uri
   * eg:
   * input: desktop/file                              output: desktop/file
   * input: desktop/folder/file                       output: desktop/folder
   * input: desktop/folder0/folder1/folder.../file    output: desktop/folder0
   * @param uris 文件uri
   * @param receivePath 接收路径
   * @returns 接收路径中 文件（夹）uri
   */
  private getFileFoldersUri(records: ESObject[], receivePath: string): string[] {
    if (records.every((record:ESObject) => !this.isFolderInReceivePath(record, receivePath))) {
      return records.map((record:ESObject):string => record.uri ?? '');
    }
    const foldersUri = this.getFoldersUri(records, receivePath);
    const filesUri = this.getFilesUri(records, receivePath);
    return filesUri.concat(foldersUri);
  }

  /**
   * 获取接收路径中文件夹的Uri，接收路径中文件夹下子文件(夹) 取其父文件夹路径
   * eg:
   * input: desktop/file                              output: []
   * input: desktop/folder/file                       output: [desktop/folder]
   * input: desktop/folder0/folder1/folder.../file    output: [desktop/folder0]
   * @param uris 文件的uri
   * @param receivePath 接收路径
   * @returns 接收路径中文件夹的uri
   */
  private getFoldersUri(records: ESObject[], receivePath: string): string[] {
    const foldersUri: Set<string> = new Set();
    records.forEach((record:ESObject) => {
      if (!this.isFolderInReceivePath(record, receivePath)) {
        return;
      }
      foldersUri.add(this.getUriInReceivePath(record.uri, receivePath));
    })
    log.showInfo(`getFoldersUri, ${foldersUri.size}`);
    return Array.from(foldersUri);
  }

  /**
   * 获取接收路径中文件uri，不包含接收路径中文件夹下的文件
   * eg:
   * input: desktop/file,                           output: [desktop/file]
   * input: desktop/folder/file,                    output: []
   * input: desktop/folder0/folder1/folder.../file  output: []
   * @param uris 文件uri
   * @param receivePath 接收路径
   * @returns 接收路径中文件uri
   */
  private getFilesUri(records: ESObject[], receivePath: string): string[] {
    const filesUri: string[] = [];
    records.forEach((record:ESObject) => {
      if (!this.isFileInReceivePath(record, receivePath)) {
        return;
      }
      filesUri.push(record.uri ?? '');
    })
    log.showInfo(`getFilesUri, ${filesUri.length}`);
    return filesUri;
  }

  private highlightFileFolder(fileFolderUris: string[]): void {
    const fileFolderManager = fileFolderManagerFactory.getFileFolderManager();
    const fileFoldersIno: string[] = [];
    const fileFoldersEncodeUri: string[] = [];
    fileFolderUris.forEach(fileFolderUri => {
      const fileFolderInfo = fileFolderManager.getFileInfoByUri(fileFolderUri);
      if (!fileFolderInfo || !fileFolderInfo.ino) {
        log.showWarn('file or file ino is undefined');
        return;
      }
      fileFoldersEncodeUri.push(fileFolderUri);
      fileFoldersIno.push(fileFolderInfo.ino);
    })
    log.showInfo(`highlightShareItem, ${fileFolderUris.length}, ${fileFoldersIno.length}`);
    PageDesktopViewModel.getInstance().selectAllOrSomeDesktopItem(fileFoldersIno);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_SELECTED, fileFoldersEncodeUri);
  }

  public getShareData(): KnockShareData {
    const knockShareData: KnockShareData = new KnockShareData();
    const desktopItems: GridLayoutItemInfo[] = this.getAllSelectItems();
    if (desktopItems.length === 0) {
      knockShareData.reportError(ShareErrorCode.NO_SHARE_DATA);
      return knockShareData;
    }
    let unSupportShareNum = 0;
    desktopItems.forEach(desktopItem => {
      if (this.isSupportShare(desktopItem.typeId)) {
        knockShareData.addRecord(this.transformToRecord(desktopItem));
      } else {
        unSupportShareNum++;
        log.showInfo(`desktopItem:${desktopItem.componentId}, ${desktopItem.bundleName}, ${desktopItem.typeId}`);
      }
    });
    if (unSupportShareNum === desktopItems.length) {
      knockShareData.reportError(ShareErrorCode.NO_SUPPORT_DATA);
    }
    return knockShareData;
  }

  private getAllSelectItems(): GridLayoutItemInfo[] {
    let selectItems = PageDesktopViewModel.getInstance().getCurrentSelectItemsInfo().flat();
    log.showInfo(`selectItemslength:${selectItems.length}`);
    return selectItems;
  }

  private isSupportShare(typeID: number | undefined): boolean {
    if (typeID === undefined) {
      return false;
    }
    switch (typeID) {
      case CommonConstants.TYPE_FOLDER: return true;
      case CommonConstants.TYPE_FILE_FOLDER: return true;
      default: return false;
    }
  }

  private transformToRecord(desktopItem: GridLayoutItemInfo): ESObject {
    let utd: string = '';
    if (desktopItem.fileType === TYPE_FILE_FOLDER) {
      utd = uniformTypeDescriptor.UniformDataType.FOLDER;
    } else {
      /*const fileSuffix = FileMimeTypeUtil.getFileSuffix(desktopItem.uri ?? '');
      utd = uniformTypeDescriptor.getUniformDataTypeByFilenameExtension('.' + fileSuffix);
      log.showInfo(`transformToRecord:${fileSuffix}, ${utd}, ${desktopItem.componentId}`);*/
    }
    const shareRecord = new KnockShareRecord(utd);
    shareRecord.uri = desktopItem.uri;
    shareRecord.title = desktopItem.fileFolderName;
    return shareRecord;
  }
}

export class KnockShareManager {
  private static instance: KnockShareManager | undefined = undefined;
  private knockShares: Map<number, KnockShare> = new Map();
  private knockShareController: KnockShareController = new KnockShareController();

  private constructor() {
  }

  public static getInstance(): KnockShareManager {
    if (!KnockShareManager.instance) {
      KnockShareManager.instance = new KnockShareManager();
    }
    return KnockShareManager.instance;
  }

  public enableKnockShare(winID: number): void {
    let knockShare = this.knockShares.get(winID);
    log.showInfo(`enableKnockShare:${winID}, ${!!knockShare}`);
    if (!knockShare) {
      knockShare = new KnockShare(winID);
      this.knockShares.set(winID, knockShare);
    } else {
      knockShare.unregisterKnockShare();
    }
    const getShareDataCallback: Callback<void, KnockShareData> = () => {
      return this.knockShareController.getShareData();
    }
    knockShare.registerKnockShare(getShareDataCallback);
  }

  public async enableKnockReceive(winID: number): Promise<void> {
    let knockShare = this.knockShares.get(winID);
    log.showInfo(`enableKnockReceive:${winID}, ${!!knockShare}`);
    if (!knockShare) {
      knockShare = new KnockShare(winID);
      this.knockShares.set(winID, knockShare);
    } else {
      // knockShare.unregisterKnockReceive();
    }
    let desktopPath: string = '';
    try {
      desktopPath = await PcFileAccess.getDesktop();
    } catch (e) {
      log.showError(`get desktop path error, code:${e?.code}, msg:${e?.message}`);
    }
    // knockShare.registerKnockReceive(new KnockReceiveCallback(this.knockShareController, desktopPath));
  }

  public disableKnockShare(winID: number): void {
    log.showInfo(`disableKnockShare:${winID}`);
    this.knockShares.get(winID)?.unregisterKnockShare();
  }

  public disableKnockReceive(winID: number): void {
    log.showInfo(`disableKnockReceive:${winID}`);
    // this.knockShares.get(winID)?.unregisterKnockReceive();
  }

  public destroyKnockShareInstance(winID: number): void {
    log.showInfo(`destroyKnockShareInstance:${winID}`);
    this.knockShares.get(winID)?.unregisterKnockShare();
    // this.knockShares.get(winID)?.unregisterKnockReceive();
    this.knockShares.delete(winID);
  }
}