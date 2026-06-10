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

import util from '@ohos.util';
import image from '@ohos.multimedia.image';
import Account from '@ohos.account.osAccount';
import CommonEventManager from '@ohos.commonEventManager';
import fs from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';
import { CheckEmptyUtils, FileUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';

const TAG = 'ScreenLock-UserIconViewModel'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const isPad: boolean = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType === 'pad';

export class UserIconViewModel {
  public userIconInfoMap: Map<number, UserIconInfo> = new Map();
  private userIconInfoUpdatedCallbackMap: Map<number, () => void> = new Map();
  private subscriber?: CommonEventManager.CommonEventSubscriber;
  private subscribeInfo: CommonEventManager.CommonEventSubscribeInfo = {
    events: [
      CommonEventManager.Support.COMMON_EVENT_USER_ADDED,
      CommonEventManager.Support.COMMON_EVENT_USER_REMOVED,
      CommonEventManager.Support.COMMON_EVENT_USER_INFO_UPDATED
    ]
  };
  private static DEFAULT_CONFIG: string = '/sys_prod/resource/avatar/list.json';
  private static instance: UserIconViewModel = new UserIconViewModel();

  private constructor() {
    // 尽量早读取所有用户图标信息，避免使用事件更新：因为会出现用户头像先是默认头像，然后又切到已设置头像的过程。
    this.initUserIconData();
    this.createUserInfoUpdatedSubscriber();
  }

  static getInstance(): UserIconViewModel {
    return UserIconViewModel.instance;
  }

  public getCurrentUserIconInfo(userId: number): UserIconInfo {
    let currentUserIconInfo: UserIconInfo | undefined = this.userIconInfoMap.get(userId);
    if (currentUserIconInfo) {
      return currentUserIconInfo;
    }
    return new UserIconInfo(userId);
  }

  public registerUserIconUpdatedCallback(userId: number, func: () => void): void {
    this.userIconInfoUpdatedCallbackMap.set(userId, func);
  }

  public unregisterUserIconUpdatedCallback(userId: number): void {
    this.userIconInfoUpdatedCallbackMap.delete(userId);
  }

  private runAllUserIconUpdatedCallback(): void {
    this.userIconInfoUpdatedCallbackMap.forEach((func: () => void) => {
      func();
    });
  }

  private runUserIconUpdatedCallback(userId: number): void {
    const func: (() => void) | undefined = this.userIconInfoUpdatedCallbackMap.get(userId);
    if (func) {
      func();
    }
  }

  private defaultIconData(): UserIconJson {
    log.showInfo('use default img');
    let defaultIcon: UserIconJson = new UserIconJson();
    try {
      const configJsonData: object = JSON.parse(fs.readTextSync(UserIconViewModel.DEFAULT_CONFIG));
      const listJson: object[] = configJsonData['list'];
      if (CheckEmptyUtils.isEmptyArr(listJson)) {
        log.showError(`default Icon config data is error`);
        return defaultIcon;
      }
      const defaultIconData: UserIconJson = listJson[0] as UserIconJson;
      if (this.isFileExist(defaultIconData.defaultImg)) {
        defaultIcon = defaultIconData;
      } else {
        log.showError(`default Icon Img path is error`);
      }
    } catch (e) {
      log.error('Error on parsing default icon configJsonData : ', e);
    }
    return defaultIcon;
  }

  private isFileExist(path: string): boolean {
    try {
      return fs.accessSync(path);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      log.showError(`accessSync failed with error message: ${err.message}, error code: ${err.code}`);
      return false;
    }
  }

  private initUserIconData(event?: string): void {
    Account.getAccountManager().queryAllCreatedOsAccounts().then((accountInfoList: Account.OsAccountInfo[]) => {
      log.showInfo(`initUserIconData for reason : ${event}`);
      if (event && event === CommonEventManager.Support.COMMON_EVENT_USER_REMOVED) {
        this.deleteUserIconData(accountInfoList);
      } else {
        for (const accountInfo of accountInfoList) {
          this.updateUserIconData(accountInfo.localId, accountInfo.photo);
        }
      }
      log.showInfo(`all user count : ${this.userIconInfoMap.size}`);
      this.runAllUserIconUpdatedCallback();
    }).catch(() => {
      log.showError('initUserIconData error');
    });
  }

  private deleteUserIconData(accountInfoList: Account.OsAccountInfo[]): void {
    // 删除用户时，清除保存的用户头像数据
    let currentUserIconList: number[] = [];
    for (const accountInfo of accountInfoList) {
      currentUserIconList.push(accountInfo.localId);
    }
    let tempIconInfoMap: Map<number, UserIconInfo> = new Map();
    this.userIconInfoMap.forEach((value, key) => {
      if (!currentUserIconList.includes(key)) {
        log.showInfo(`delete user id : ${key}`);
        this.releaseUnusedPixelMap(value);
      } else {
        tempIconInfoMap.set(key, value);
      }
    })
    this.userIconInfoMap = tempIconInfoMap;
  }

  private updateUserIconData(userNum: number, photoStr: string): void {
    log.showInfo(`updateUserIconData usr : ${userNum}`);
    let currentUserIconInfo: UserIconInfo;
    let oldUserIconInfo: UserIconInfo | undefined = this.userIconInfoMap.get(userNum);
    if (oldUserIconInfo) {
      currentUserIconInfo = oldUserIconInfo;
    } else {
      currentUserIconInfo = new UserIconInfo(userNum);
      this.userIconInfoMap.set(userNum, currentUserIconInfo);
    }
    const userIconData: UserIconJson =
      CheckEmptyUtils.isEmpty(photoStr) ? this.defaultIconData() : JSON.parse(photoStr) as UserIconJson;
    const defaultImg: string = userIconData.defaultImg;
    if (currentUserIconInfo.iconPath === defaultImg) {
      log.showInfo('The icon is not updated');
      return;
    }
    this.releaseUnusedPixelMap(currentUserIconInfo);
    currentUserIconInfo.iconPath = defaultImg;

    if (CheckEmptyUtils.isEmpty(defaultImg)) {
      log.showWarn('iconPath is empty, use default img');
      currentUserIconInfo = new UserIconInfo(userNum);
      this.userIconInfoMap.set(userNum, currentUserIconInfo);
      return;
    }
    const iconType: string = userIconData.type;
    let iconTypeNumber: number = parseInt(iconType);
    log.showInfo(`use iconType: ${iconTypeNumber}`);
    switch (iconTypeNumber) {
      case IconImgType.CLIP:
        this.createClipImage(currentUserIconInfo);
        break;
      case IconImgType.STATIC:
        this.createStaticImage(currentUserIconInfo);
        break;
      case IconImgType.EMOJI:
        this.createEmojiInfo(currentUserIconInfo);
        break;
      case IconImgType.EMOJI_3D:
        this.createEmoji3DInfo(currentUserIconInfo, userIconData);
        break;
      default:
        break;
    }
  }

  private createClipImage(currentUserIconInfo: UserIconInfo): void {
    this.base64ToPixelMap(currentUserIconInfo.iconPath).then((pixelMap: PixelMap | null) => {
      if (pixelMap) {
        log.showInfo('use clip icon success');
        currentUserIconInfo.iconImage = pixelMap;
        currentUserIconInfo.iconType = IconImgType.CLIP;
        // 异步数据处理，需要在处理完成时再回调更新数据
        this.runUserIconUpdatedCallback(currentUserIconInfo.userId);
      } else {
        log.showWarn('clip icon is empty');
      }
    }).catch(() => {
      log.showError('pixelMap error');
    })
  }

  private async base64ToPixelMap(base64Str: string): Promise<PixelMap | null> {
    if (!base64Str) {
      return null;
    }
    const base64Helper: util.Base64Helper = new util.Base64Helper();
    // 解码前先去掉前缀
    const prefix: string = 'data:image/jpeg;base64,';
    if (base64Str.startsWith(prefix)) {
      base64Str = base64Str.substring(prefix.length);
    }
    let imageSource: image.ImageSource | undefined = undefined;
    try {
      const data = base64Helper.decodeSync(base64Str, util.Type.BASIC);
      imageSource = image.createImageSource(data.buffer);
      let pixelMap: PixelMap = await imageSource.createPixelMap({ editable: true });
      return pixelMap;
    } catch (err) {
      log.showError(`decode base64 failed message is ${JSON.stringify(err)}`);
    } finally {
      if (imageSource) {
        imageSource.release();
        log.showInfo('release ImageSource');
      }
    }
    return null;
  }

  private createStaticImage(currentUserIconInfo: UserIconInfo): void {
    const staticIcon: string = FileUtils.getUriFromPath(currentUserIconInfo.iconPath);
    if (CheckEmptyUtils.isEmpty(staticIcon)) {
      log.showWarn('static icon is empty');
      return;
    }
    log.showInfo('use static icon success');
    currentUserIconInfo.iconImage = staticIcon;
    currentUserIconInfo.iconType = IconImgType.STATIC;
  }

  private createEmojiInfo(currentUserIconInfo: UserIconInfo): void {
    const emojiStaticIcon: string = FileUtils.getUriFromPath(currentUserIconInfo.iconPath);
    if (CheckEmptyUtils.isEmpty(emojiStaticIcon)) {
      log.showWarn('emoji static icon is empty');
      return;
    }
    // emoji头像当前不再演进，但已开发完成的"笑脸"留存。若用户选择emoji头像，不再解析，默认显示已有的"笑脸"头像.
    log.showInfo('use emoji icon success');
    currentUserIconInfo.iconImage = emojiStaticIcon;
    currentUserIconInfo.iconType = IconImgType.EMOJI;
  }

  private createEmoji3DInfo(currentUserIconInfo: UserIconInfo, userIconData: UserIconJson): void {
    const imgDir: string = userIconData.path;
    const imgName: string = userIconData.name;
    const emojiStaticIcon: string = FileUtils.getUriFromPath(currentUserIconInfo.iconPath);
    if (CheckEmptyUtils.isEmpty(imgDir) || CheckEmptyUtils.isEmpty(imgName) ||
      CheckEmptyUtils.isEmpty(emojiStaticIcon)) {
      log.showError('emoji 3D static icon is empty');
      return;
    }
    // 解析配置文件数据，保存解析出的图像路径
    let emojiData: Emoji3dData = new Emoji3dData();
    const currentData: Emoji3dJson = this.createEmoji3dDataFromJson(imgDir + '/config.json');
    emojiData.commonLightImg = FileUtils.getUriFromPath(imgDir + currentData.common.light);
    emojiData.commonShadowImg = FileUtils.getUriFromPath(imgDir + currentData.common.shadow);
    for (let i: number = 0; i < currentData.base.length; i++) {
      if (currentData.base[i].name === imgName) {
        emojiData.baseBodyImg = FileUtils.getUriFromPath(imgDir + currentData.base[i].body);
        break;
      }
    }
    currentUserIconInfo.iconImage = emojiStaticIcon;
    currentUserIconInfo.iconType = IconImgType.EMOJI_3D;
    currentUserIconInfo.iconImageMap.set(currentUserIconInfo.iconType.toString(), emojiData);
    log.showInfo('use emoji 3D icon success');
  }

  private createEmoji3dDataFromJson(filePath: string): Emoji3dJson {
    try {
      const text: string = fs.readTextSync(filePath);
      return JSON.parse(text) as Emoji3dJson;
    } catch (e) {
      log.error('getJsonStringFromFile failed');
    }
    return new Emoji3dJson();
  }

  private releaseUnusedPixelMap(userIconInfo: UserIconInfo): void {
    // 不再使用的PixelMap数据需要手动释放，否则会导致资源泄露
    try {
      if (userIconInfo.iconImage && (userIconInfo.iconImage as PixelMap).isEditable !== undefined) {
        (userIconInfo.iconImage as PixelMap).release();
        log.showInfo(`releaseUnusedPixelMap`);
      }
    } catch (e) {
      log.error('releaseUnusedPixelMap error:', e);
    }
  }

  private subscriberCB: (err: BusinessError, data: CommonEventManager.CommonEventData) => void =
    (err: BusinessError, data: CommonEventManager.CommonEventData) => {
      if (err) {
        log.error(`subscriber error: code ${err.code}, message: ${err.message}`);
        return;
      }
      this.initUserIconData(data.event);
    }

  private createUserInfoUpdatedSubscriber(): void {
    try {
      CommonEventManager.createSubscriber(this.subscribeInfo,
        (err: BusinessError, eventSubscriber: CommonEventManager.CommonEventSubscriber) => {
          if (err) {
            log.error(`create subscriber error: code ${err.code}, message: ${err.message}`);
            return;
          }
          log.info('createSubscriber');
          this.subscriber = eventSubscriber;
          // 订阅公共事件
          try {
            CommonEventManager.subscribe(this.subscriber, this.subscriberCB);
          } catch (error) {
            log.error(`subcribe error: ${error}`);
          }
        })
    } catch (error) {
      log.error(`subcribe error: ${error}`);
    }
  }

  private cancelUserInfoUpdatedSubscriber(): void {
    try {
      if (this.subscriber) {
        log.info('cancelSubscriber');
        CommonEventManager.unsubscribe(this.subscriber);
      }
    } catch (error) {
      log.error(`unsubscribe error :${error}`);
    }
  }

  destroy(): void {
    this.cancelUserInfoUpdatedSubscriber();
  }
}

export class UserIconInfo {
  public userId: number = 0;
  public iconImage: PixelMap | ResourceStr | DrawableDescriptor | undefined = undefined;
  public iconPath: string = '';
  public iconType: number = IconImgType.STATIC;
  public iconImageMap: Map<string, object> = new Map();

  constructor(userId: number) {
    this.userId = userId;
  }
}

export enum IconImgType {
  CLIP = 0,
  STATIC = 1,
  EMOJI = 2,
  EMOJI_3D = 3
}

export class Emoji3dData {
  public commonLightImg: ResourceStr = '';
  public commonShadowImg: ResourceStr = '';
  public baseBodyImg: ResourceStr = '';
  public baseBackgroundImg: ResourceStr = '';
  public backgroundOpacity: number = 1;
}

class UserIconJson {
  public type: string = '';
  public path: string = '';
  public name: string = '';
  public defaultImg: string = '';
}

class Emoji3dJson {
  public common: Emoji3dCommonJson = new Emoji3dCommonJson();
  public base: Emoji3dBaseJson[] = [];
}

class Emoji3dCommonJson {
  public light: string = '';
  public shadow: string = '';
}

class Emoji3dBaseJson {
  public name: string = '';
  public body: string = '';
  public background: string = '';
}