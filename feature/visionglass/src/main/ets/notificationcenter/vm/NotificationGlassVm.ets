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

import { wantAgent } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import notificationManager from '@ohos.notificationManager';
import { WantAgent } from '@ohos.wantAgent';
import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { BaseNotification } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { GlassSceneManager } from '../../scene/common/GlassSceneManager';
import { GlassShowToastOptions, GlassToastManager } from '../../toast/manager/GlassToastManager';
import NotificationConstant from '../common/NotificationConstant';
import { NotificationGlassVmArray } from './NotificationVmItemArray';
import { GlassAppWhiteListManager } from './../../common/manager/GlassAppWhiteListManager'
import { ArrayUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import GlassNtfConstant from '../../bannerpanel/common/GlassNtfConstant';
import { NtfToastCommon } from '../../common/constants/GlassLayoutConstants';
import { GlassSystemSceneManager, GlassSystemSceneType } from '../../scene/common/GlassSystemSceneManager';
import { GlassNtfListVm } from './GlassNtfListVm';

const TAG: string = 'Ntf-NotificationGlassVmItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

export const OTHER_APP_TRANSPORT = 'com.ohos.pushservice';

/**
 * 通知数据VM实体类
 */
@Observed
export class NotificationGlassVm extends BaseNotification {
  /**
   * 标记是否为组通知数据
   */
  public isGroup: boolean = false;
  /**
   * 通知删除原因
   */
  public reason: number = -1;
  /**
   * 子消息组
   */
  public childrenArr: NotificationGlassVmArray = new NotificationGlassVmArray();
  /**
   * 是否置顶显示
   */
  public isDisplayAtTop: boolean = false;
  /**
   * 通知按钮集
   */
  public actionButtons: NotificationAction[] = [];

  /*
   * 更新来自手机的通知对象
   *
   * @param notificationEntry
   * */
  public updateDataFromPhone(notificationEntry: NotificationEntry | NotificationGlassVm): void {
    if (!notificationEntry) {
      log.showInfo(`updateDataFromPhone cancel,notificationEntry is invalid`);
      return;
    }
    this.hashCode = notificationEntry.hashCode;
    this.creatorBundleName = notificationEntry.creatorBundleName;
    this.reason = notificationEntry.reason!;
    this.groupName = notificationEntry.groupName;
    this.appIndex = notificationEntry.appIndex;
    this.deliveryTime = notificationEntry.deliveryTime;
    this.notificationContent = notificationEntry.notificationContent;
    this.actionButtons = notificationEntry.actionButtons;
    this.isDeliverNotification = notificationEntry.isDeliverNotification;
    this.appIcon = notificationEntry.appIcon;
    this.isFromSystemApp = notificationEntry.isFromSystemApp;
    this.smallIcon = notificationEntry.smallIcon;
    this.wantAgent = notificationEntry.wantAgent;
    this.wantAgentInfo = notificationEntry.wantAgentInfo;
    this.slotType = notificationEntry.slotType;
    this.isDisplayAtTop = notificationEntry.isDisplayAtTop;
    this.liveViewData = notificationEntry.liveViewData;
    if (notificationEntry.creatorBundleName === NotificationConstant.PHONE_BUNDLE_NAME) {
      this.isDisplayAtTop = true;
    }
  }

  /**
   * 打印简单属性
   *
   * @return 打印信息
   */
  public toSimpleString(): string {
    return ('group: ' + this.groupName + ', ' + this.isGroup + ', bundle: ' +
    this.creatorBundleName + ', hash: ' + this.hashCode + ', appIndex: ' + this.appIndex + ', deliveryTime：' +
    this.deliveryTime);
  }

  /*
   * 获取appIcon资源
   *
   * @param isOnlyUseAppIcon
   * @return image.PixelMap | string | undefined
   * */
  public getAppIcon(isOnlyUseAppIcon: boolean): image.PixelMap | string | undefined {
    // 优先级最高
    if (this.isDeliverNotification && this.appIcon) {
      log.showInfo('getAppIcon, isDeliverNotification == true, return appIcon');
      return this.appIcon;
    }
    // 系统应用支持自定义图标，使用小图标代替应用图标
    if (this.isFromSystemApp && !CommonUtils.isInvalid(this.smallIcon)) {
      log.showInfo('getAppIcon, isFromSystemApp == true, return smallIcon');
      return this.smallIcon;
    }
    if (isOnlyUseAppIcon && this.appIcon) {
      log.showInfo('getAppIcon, isOnlyUseAppIcon == true, return appIcon');
      return this.appIcon;
    }
    if (this.smallIcon) {
      log.showInfo('getAppIcon, smallIcon exist, return smallIcon');
      return this.smallIcon;
    }
    log.showInfo(`getAppIcon, other, return appIcon, appIcon is undefined:${this.appIcon === undefined}`);
    return this.appIcon;
  }

  /**
   * 获取分组通知中第一个子通知
   *
   * @returns 第一个子通知
   */
  public getFirstChild(notificationGlassVm: NotificationGlassVm): NotificationGlassVm {
    if (ArrayUtils.isEmpty(this.childrenArr)) {
      return notificationGlassVm;
    }
    return this.childrenArr[0];
  }

  /**
   * 组通知中移除child通知
   *
   * @param ntfItem 待删除的child通知
   * @returns true:移除成功
   */
  public removeChild(ntfItem?: NotificationEntry | NotificationGlassVm): boolean {
    let findIndex = this.childrenArr.findIndex((child) => child.hashCode === ntfItem?.hashCode);
    log.showInfo(`findIndex:${findIndex}`);
    const notFindIndex: number = -1;
    if (findIndex === notFindIndex) {
      return false;
    }
    this.childrenArr.splice(findIndex, 1)
    log.showInfo(`index:${findIndex}`);
    if (this.getChildrenSize() > 0) {
      this.deliveryTime = this.childrenArr[0].deliveryTime;
    }
    return true;
  }

  /**
   * 分组通知子通知集排序
   */
  public sortChildren(): void {
    if (!this.isGroup) {
      return;
    }
    if (ArrayUtils.isEmpty(this.childrenArr)) {
      return;
    }
    this.childrenArr.sort((entryA, entryB): number => {
      if (entryA.isDisplayAtTop || entryB.isDisplayAtTop) {
        if (entryA.isDisplayAtTop !== entryB.isDisplayAtTop) {
          return entryA.isDisplayAtTop ? -1 : 1;
        }
      }
      return entryB.deliveryTime - entryA.deliveryTime;
    });
  }

  /**
   * 获取分组通知中子通知个数
   *
   * @returns 子通知个数
   */
  public getChildrenSize(): number {
    return ArrayUtils.getSize(this.childrenArr);
  }

  /*
   * 获取列表渲染key值
   * */
  public getListKey(): string {
    return this.hashCode + this.creatorBundleName + this.deliveryTime + JSON.stringify(this.notificationContent) +
    this.isGroup;
  }
}

/**
 * 通知action按钮数据
 */
export class NotificationAction {
  /**
   * 按钮标题
   */
  public actionTitle: string;
  /**
   * 按钮点击事件调用远程
   */
  public wantAgent: WantAgent;
  /**
   * 用户输入时标示
   */
  public userInputKey?: string;
  /**
   * 更新计数值
   */
  public updateCount: number;

  /**
   * 构造
   *
   * @param action 原action
   */
  public constructor(action: notificationManager.NotificationActionButton) {
    this.actionTitle = action.title;
    this.wantAgent = action.wantAgent;
    this.userInputKey = action.userInput?.inputKey;
    this.updateCount = 0;
  }

  /**
   * 设置更新计数值
   *
   * @param count 计数值
   */
  public setUpdateCount(count: number): void {
    this.updateCount = count;
  }

  /**
   * 获取更新计数值
   *
   * @return 更新计数值
   */
  public getUpdateCount(): number {
    return this.updateCount;
  }
}

export class NotificationUtil {
  public static readonly inComeCallTitle: string = '来电';

  public static clickNft(notificationGlassVm: NotificationGlassVm | null): void {
    if (!notificationGlassVm) {
      return;
    }
    log.showInfo(`clickNft start,hashcode is ${notificationGlassVm.hashCode}`);
    let checkBundleName: string = notificationGlassVm.creatorBundleName === NotificationConstant.PHONE_BUNDLE_NAME ?
    NotificationConstant.CONTACT_BUNDLE_NAME : notificationGlassVm.creatorBundleName;
    let appWant: Want | undefined = GlassAppWhiteListManager.getInstance().getWhiteListAppWant(checkBundleName);
    if (!appWant) {
      let options: GlassShowToastOptions = {
        message: NtfToastCommon.CAN_NOT_OPEN_MSG,
        bottom: NtfToastCommon.TOAST_BOTTOM,
        duration: NtfToastCommon.TOAST_DURATION,
        width: NtfToastCommon.CAN_NOT_OPEN_MSG_WID
      }
      GlassToastManager.getInstance().showToast(options);
      return;
    }
    if (notificationGlassVm.creatorBundleName === GlassSceneManager.getInstance().getActiveWant()?.bundleName) {
      GlassNtfListVm.getInstance().clearByGlass(notificationGlassVm)
      GlassSystemSceneManager.getInstance().hideSystemView(GlassSystemSceneType.GLASS_NOTIFICATION_CENTER);
      log.showInfo(`clickNft,window is alreay exist,hashcode is ${notificationGlassVm.hashCode}`);
      return;
    }
    const agent: WantAgent = notificationGlassVm.wantAgent;
    let triggerInfo: wantAgent.TriggerInfo = {
      code: 0,
      startOptions: { displayId: GlassSceneManager.getInstance().getScreenId() }
    };
    let triggerCallback = (err?: BusinessError) => {
      if (err) {
        log.showError(`getUid failed! ${err.code} ${err.message}`);
      }
    }
    try {
      wantAgent.getWant(agent).then((data) => {
        if (data.bundleName === OTHER_APP_TRANSPORT) {
          // 利用窗口加载对应应用
          log.showInfo(`clickNft,startSceneFromIcon,hashcode is ${notificationGlassVm.hashCode}`);
          GlassSceneManager.getInstance().startSceneFromIcon({
            bundleName: appWant?.bundleName,
            abilityName: appWant?.abilityName,
            moduleName: appWant?.moduleName
          });
          GlassNtfListVm.getInstance().clearByGlass(notificationGlassVm);
          GlassSystemSceneManager.getInstance().hideSystemView(GlassSystemSceneType.GLASS_NOTIFICATION_CENTER);
        } else {
          log.showInfo(`clickNft,startScene by trigger,hashcode is ${notificationGlassVm.hashCode}`);
          try {
            wantAgent.trigger(agent, triggerInfo, triggerCallback);
            GlassNtfListVm.getInstance().clearByGlass(notificationGlassVm);
            GlassSystemSceneManager.getInstance().hideSystemView(GlassSystemSceneType.GLASS_NOTIFICATION_CENTER);
          } catch (err) {
            log.showError(`getUid failed! ${err.code} ${err.message}`);
          }
          return;
        }
      }).catch((err: BusinessError) => {
        log.showError(`getWant failed, code: ${err.code}, message: ${err.message}`);
      });
    } catch (err) {
      log.showError(`getWant failed! ${err.code} ${err.message}`);
    }
  }

  public static isNtfAsRequired(notificationGlassVm: NotificationGlassVm): boolean {
    if (notificationGlassVm.isLiveType() &&
      notificationGlassVm.creatorBundleName !== NotificationConstant.PHONE_BUNDLE_NAME) {
      log.showInfo('notificationGlassVm is LiveType');
      return false;
    }
    if (!notificationGlassVm.isLiveType()) {
      if (notificationGlassVm.notificationContent.contentTitle === NotificationConstant.EMPTY_STRING ||
        notificationGlassVm.notificationContent.contentText === NotificationConstant.EMPTY_STRING ||
        !notificationGlassVm.deliveryTime) {
        log.showInfo('notificationGlassVm notificationContent is empty');
        return false;
      }
      if (notificationGlassVm.actionButtons.length > 0 &&
        notificationGlassVm.creatorBundleName !== NotificationConstant.MESSAGE_BUNDLE_NAME) {
        log.showInfo(`isNtfAsRequired,not message app but with buttons`);
        return false;
      }
      return true;
    }
    return true;
  }

  /*
   * 判断当前消息是否属于通话消息
   *
   * @param notification entry
   * @return checkIsCallNtf boolean
   * */
  public static checkIsCallNtf(ntf: NotificationEntry | NotificationGlassVm): boolean {
    log.showInfo(`checkIsCallNtf,typeCode is ${ntf.liveViewData?.capsule?.typeCode}`);
    return ntf.creatorBundleName === GlassNtfConstant.PHONE_BUNDLE_NAME && ntf.liveViewData?.capsule?.typeCode === 0
  }

  /*
   * 检查当前消息是否属于不合法通话消息
   *
   * @param notification entry
   * @return checkIsCallNtf boolean
   * */
  public static checkIsInvalidCallNtf(ntf: NotificationEntry | NotificationGlassVm): boolean {
    log.showInfo(`checkIsInvalidCallNtf,title is ${ntf.liveViewData?.capsule?.title}`);
    log.showInfo(`checkIsInvalidCallNtf,resource is ${getContext()
      .resourceManager
      .getStringSync($r('app.string.Incoming_call_flag'))}`)
    return ntf.creatorBundleName === GlassNtfConstant.PHONE_BUNDLE_NAME &&
      ntf.liveViewData?.capsule?.title !==
      getContext().resourceManager.getStringSync($r('app.string.Incoming_call_flag'));
  }

  /*
   * 判断消息是否来自短信
   * */
  public static isNtfContact(ntf: NotificationEntry): boolean {
    log.showInfo(`isNtfContact`);
    if (ntf.creatorBundleName === GlassNtfConstant.MESSAGE_BUNDLE_NAME) {
      log.showInfo(`isNtfContact,true`);
      return true;
    }
    return false;
  }

  /*
   * 获取当前消息标题
   * */
  public static getNtfTitle(ntf: NotificationEntry): string {
    let title = '';
    if (!ntf) {
      return title;
    }
    if (ntf.isExpandable) {
      title = ntf.notificationContent.expandedTitle;
    } else {
      title = ntf.notificationContent.contentTitle;
    }
    return title;
  }

  /*
   * 获取当前消息内容
   * */
  public static getNtfContent(ntf: NotificationEntry): string {
    let content = '';
    if (!ntf) {
      return content;
    }
    if (ntf.isExpandable) {
      content = ntf.notificationContent.expandedContentText;
    } else {
      content = ntf.notificationContent.contentText;
    }
    return content;
  }

  public static isHintNtf(ntf: NotificationEntry): boolean {
    log.showInfo(`isNtfAsRequired`);
    if (!ntf) {
      return false;
    }
    if (ntf.isLiveType() && ntf.creatorBundleName !== GlassNtfConstant.PHONE_BUNDLE_NAME) {
      return false;
    }
    if (!ntf.isLiveType()) {
      if (NotificationUtil.getNtfTitle(ntf) === '' || NotificationUtil.getNtfContent(ntf) === '' || !ntf.deliveryTime) {
        return false;
      }
    }
    if (ntf.actionButtons.length > 0 && !NotificationUtil.isNtfContact(ntf)) {
      return false;
    }
    log.showInfo(`isNtfAsRequired,true`);
    return true;
  }
}

