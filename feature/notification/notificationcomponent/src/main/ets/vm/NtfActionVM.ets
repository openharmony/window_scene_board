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

import { NotificationEntry } from '../model/NotificationEntry';
import { ntfMgr } from '../model/NotificationManager';
import { NotificationPanelManager } from '../model/NotificationPanelManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { NotificationType } from '../common/NotificationType';
import { ScreenLockApi } from '@ohos/screenlockcommon/src/main/ets/api/ScreenLockApi';
import wantAgentController, { WantAgent } from '@ohos.app.ability.wantAgent';
import { bannerMgr, LiveUseScene, NotificationAction } from '@ohos/systemuicommon';
import { ExclusiveChecker } from '../model/ExclusiveChecker';
import {
  ClickNotificationErrorCode,
  ClickNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/ClickNotificationMaintenance';
import { AnimParam } from '@ohos/systemuicommon/src/main/ets/liveview/common/LiveItemStartAnimManager';
import { SlMainStateType, SlStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import {
  DeleteNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/DeleteNotificationMaintenance';
import { ClickRegion, DeleteNotificationType } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { liveStartAnimMgr } from '@ohos/systemuicommon/Index';
import Want from '@ohos.app.ability.Want';
import { NtfSingleItemVM } from './NtfSingleItemVM';
import NTF_LIST_VM_HOLDER from '../model/NtfListVmHolder';
import { NotificationUtil } from '@ohos/systemuicommon/src/main/ets/utils/NotificationUtil';

const TAG = 'NtfActionVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const UNLOCK_DELAY = 300;

/**
 * 通知action按钮VM
 *
 * @since 2022-12-22
 */
export class NtfActionVM {
  /**
   * 组件回调器
   */
  protected callback: ActionCallback | null = null;

  protected ntfItemVM?: NtfSingleItemVM;

  /**
   * 初始化
   *
   * @param callback 组件回调器
   */
  init(callback: ActionCallback, ntfItemVM?: NtfSingleItemVM): void {
    this.callback = callback;
    this.ntfItemVM = ntfItemVM;
  }

  /**
   * 销毁
   */
  onDestroy(): void {
    if (this.callback) {
      this.callback = null;
    }
  }

  /**
   * 通知action点击跳转
   */
  startNtfAction(action: NotificationAction, isAutoCancel: boolean, isHeadsUp: boolean, inputContent?: string): void {
    let entry = this.callback?.getNtfEntry();
    ClickNotificationMaintenance.saveInfo({
      data: entry,
      clickRegion: isHeadsUp ? ClickRegion.BANNER_BUTTON : ClickRegion.CONTENT_BUTTON,
    });
    if (!entry) {
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.NO_ENTRY);
      log.showInfo('Cannot start ntf action, invalid entry');
      return;
    }
    log.showInfo('startNtfAction: ' + entry?.hashCode + ', ' + entry?.getGroupTypeKey() + `,isDeliverNotification is:` +
      entry?.isDeliverNotification);
    // 非横幅状态则为通知中心按钮触发，此时需关闭旋转锁定，防止拉起的应用方向不对
    if (!isHeadsUp) {
      const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
      screenSession?.setEnableRotate(true, WindowConstants.WINDOW_NAME_DROPDOWN);
    }
    if (this.isExcludeForStartApp(entry)) {
      if (isHeadsUp) {
        bannerMgr.releasePanelHeadsUp();
      } else {
        NotificationPanelManager.collapseNtfPanel(this.callback ? this.callback.getNtfType() : 0, true);
      }
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.DELIVER_EXCLUDE);
      return;
    }
    this.checkAndStart(action, isAutoCancel, inputContent);
  }

  /**
   * check ui jump and start
   *
   * @param action action
   * @param isAutoCancel ntfs's autoCancel
   * @param inputContent inputContent
   */
  checkAndStart(action: NotificationAction, isAutoCancel: boolean, inputContent?: string): void {
    log.showInfo('When checkAndStart, wantAgent is missing [%{public}s]', !action?.wantAgent);
    if (!action?.wantAgent) {
      ClickNotificationMaintenance.updateErrorCode(ClickNotificationErrorCode.NO_WANTAGENT);
      this.startActionInner(action, isAutoCancel, true, inputContent);
      return;
    }

    try {
      log.showInfo('Start call getOperationType');
      Promise.all([
        wantAgentController.getWant(action.wantAgent),
        wantAgentController.getOperationType(action.wantAgent)
      ]).then((ret: [Want, number]) => {
        const bundleName = ret[0]?.bundleName;
        const operType = ret[1];
        let entry = this.callback?.getNtfEntry();
        this.startWantAgent(entry, bundleName, action, inputContent, isAutoCancel, operType, ret[0]);
      }).catch((err: Error) => {
        log.showError('getOperationType failed1');
        ClickNotificationMaintenance.updateErrorCode(ClickNotificationErrorCode.WANT_AGENT_GET_TYPE_ERROR);
        this.startActionInner(action, isAutoCancel, true, inputContent);
      });
    } catch (err) {
      log.showError('getOperationType failed2');
      ClickNotificationMaintenance.updateErrorCode(ClickNotificationErrorCode.WANT_AGENT_GET_TYPE_ERROR);
      this.startActionInner(action, isAutoCancel, true, inputContent);
    }
  }

  private startWantAgent(
    entry: NotificationEntry | undefined,
    bundleName: string | undefined,
    action: NotificationAction,
    inputContent: string | undefined,
    isAutoCancel: boolean,
    operType: number,
    targetWant?: Want) {
    let isAbility: boolean = Boolean(operType !== wantAgentController.OperationType.SEND_COMMON_EVENT ||
      entry?.isDeliverNotification);
    if (this.callback?.getNtfType() === NotificationType.TYPE_PHONE_DROPDOWN && entry && this.ntfItemVM) {
      if (!this.callback?.isHeadsUpNtf || !this.callback?.isHeadsUpNtf()) {
        const ntfCenterVm = NTF_LIST_VM_HOLDER.getNtfListVmInstance(NotificationType.TYPE_PHONE_DROPDOWN);
        this.ntfItemVM.setNtfCenterOverlayAnim(ntfCenterVm, isAbility);
        isAbility && this.ntfItemVM.handleNtfPanelCollapseByWant(entry, NotificationType.TYPE_PHONE_DROPDOWN, operType);
        let callback = () => {
          let callbackForRemoveNotification = (data: number) => {
            if (isAutoCancel && entry?.isAutoDelete) {
              DeleteNotificationMaintenance.addNtfMap([entry], DeleteNotificationType.NOTIFICATION_CLICK_DELETE, false);
              isAbility && ntfCenterVm?.setUpdateFreeze('OverlayAnim');
              ntfMgr.removeNotificationByClick(entry);
            }
          };

          let startAction = () => {
            // 正常执行
            ntfMgr.startWantAgent(action.wantAgent, callbackForRemoveNotification, action.userInputKey, inputContent);
          };
          // 正常执行
          startAction();
        };
        let param: AnimParam = {
          cardId: entry.hashCode,
          startBundleName: bundleName,
          cardComponentId: this.ntfItemVM.getCardComponentId(LiveUseScene.SCENE_NTF_CENTER, entry),
          scene: LiveUseScene.SCENE_NTF_CENTER,
          onPreComplete: callback,
          isNeedCollapseDropdownPanel: isAbility,
          isLockScreen: this.callback?.isNtfKeyguard?.()
        };
        if (this.callback?.isNtfKeyguard?.()) {
          this.startAnimInNtfKeyguard(callback, () => liveStartAnimMgr.startAnimPre(param));
        } else {
          liveStartAnimMgr.startAnimPre(param);
        }
      } else {
        const isTargetForegroundApp =
          NotificationUtil.isTargetAppForeground(entry.creatorBundleName, entry.appIndex, targetWant);
        if (isTargetForegroundApp) {
          let callbackForRemoveNotification = (data: number) => {
            log.showWarn(`button clicked, isAutoCancel:${isAutoCancel}, isAutoDelete:${entry?.isAutoDelete}`);
            if (isAutoCancel && entry?.isAutoDelete) {
              DeleteNotificationMaintenance.addNtfMap([entry], DeleteNotificationType.NOTIFICATION_CLICK_DELETE, false);
              ntfMgr.removeNotificationByClick(entry);
            }
          };
          ntfMgr.startWantAgent(action.wantAgent, callbackForRemoveNotification, action.userInputKey, inputContent);
          return;
        }
        this.startAnimPreInHeadsUp(entry, () => this.startActionInner(action, isAutoCancel, isAbility, inputContent));
      }
    } else {
      this.startActionInner(action, isAutoCancel, isAbility, inputContent);
    }
  }

  private startAnimInNtfKeyguard(requestUnlockCallback: () => void, unlockCallback: () => void): void {
    if (this.getKeyguardLock()) {
      ScreenLockApi.requestUnlock({
        success: () => {
          requestUnlockCallback();
        }
      });
      return;
    }
    ScreenLockApi.notifyEarlyUnlockTransition();
    unlockCallback();
    ScreenLockApi.requestUnlock(undefined);
  }

  private startAnimPreInHeadsUp(entry: NotificationEntry | undefined, onPreComplete: () => void): void {
    if (!entry || !this.ntfItemVM) {
      return;
    }
    let param: AnimParam = {
      cardId: entry.hashCode,
      startBundleName: entry.getLauncherBundleName(),
      cardComponentId: this.ntfItemVM.getCardComponentId(LiveUseScene.SCENE_HEADS_UP, entry),
      scene: LiveUseScene.SCENE_HEADS_UP,
      onPreComplete: onPreComplete
    };
    if (!this.callback?.isNtfKeyguard?.()) {
      liveStartAnimMgr.startAnimPre(param);
      return;
    }
    this.startAnimInNtfKeyguard(onPreComplete, () => liveStartAnimMgr.startAnimPre(param));
  }

  /**
   * start notification action
   *
   * @param action action
   * @param isAutoCancel ntfs's autoCancel
   * @param isAbility isUI jump
   * @param inputContent inputcontent
   */
  startActionInner(action: NotificationAction, isAutoCancel: boolean, isAbility: boolean, inputContent?: string): void {
    let entry = this.callback?.getNtfEntry();
    let callback = () => this.startActionWantAgent(action,
      isAutoCancel,
      isAbility,
      entry as NotificationEntry,
      inputContent);
    if (isAbility) {
      if (this.callback?.isNtfKeyguard?.()) {
        this.startAnimInNtfKeyguard(callback, callback);
        return;
      }
      if (this.isKeyguard()) {
        ScreenLockApi.requestUnlock({
          success: (): void => callback()
        });
        return;
      }
    }
    callback();
  }

  /**
   * 是否为锁屏界面
   *
   * @return true 锁屏界面
   */
  isKeyguard(): boolean {
    return NotificationType.isKeyguard(this.callback ? this.callback.getNtfType() : 0);
  }

  /**
   * 获取锁屏锁定状态
   */
  protected getKeyguardLock(): boolean {
    let isKeyguardLock = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE)
    ?.getSlState(SlStaticStateType.SL_SECURE_LOCKED_STATE) as boolean;
    return isKeyguardLock;
  }

  /**
   * action拉起远程wantAgent
   *
   * @param action action数据
   * @param isAutoCancel 是否自动取消通知
   * @param ntfEntry 通知数据
   * @param inputContent 输入内容
   */
  public startActionWantAgent = (action: NotificationAction,
                                  isAutoCancel: boolean,
                                  isStartAbility: boolean,
                                  ntfEntry: NotificationEntry,
                                  inputContent?: string
                                ): void => {
    const ntfType = this.callback ? this.callback.getNtfType() : 0;
    log.showInfo('startActionWantAgent action: ' + action.actionTitle + ', isAutoCancel: ' + isAutoCancel +
      ', isAutoDelete: ' + ntfEntry?.isAutoDelete + ', ntf: ' + ntfEntry?.hashCode + ', ' +
    ntfEntry?.getGroupTypeKey() + 'ntfType is:' + ntfType);
    let callbackForRemoveNotification = (data: number) => {
      if (isAutoCancel && ntfEntry?.isAutoDelete) {
        DeleteNotificationMaintenance.addNtfMap([ntfEntry], DeleteNotificationType.NOTIFICATION_CLICK_DELETE, false);
        ntfMgr.removeNotificationByClick(ntfEntry);
      }
      if (isStartAbility) {
        // 收起面板
        NotificationPanelManager.collapseNtfPanel(ntfType, true);
      }
    };

    let startAction = () => {
      // 正常执行
      ntfMgr.startWantAgent(action.wantAgent, callbackForRemoveNotification, action.userInputKey, inputContent);
    };

    // 正常执行
    startAction();
  }

  /**
   * 通知拉起应用前需要检查当前是否为重载业务，如果是则不打开应用，并且提示用户
   * @returns true表示当前不打开应用
   */
  private isExcludeForStartApp(entry: NotificationEntry): boolean {
    if (this.isKeyguard()) {
      return false;
    }
    const exclusive = ExclusiveChecker.check(entry.creatorBundleName, 'FULL_SCREEN', true);
    return exclusive.result;
  }
}

/**
 * 组件回调器
 */
export interface ActionCallback {
  /**
   * 获取通知数据
   *
   * @return 通知数据
   */
  getNtfEntry(): NotificationEntry;

  /**
   * 获取通知面板类型
   *
   * @return 通知面板类型
   */
  getNtfType(): number;

  /**
   * 是否是锁屏上的通知中心或临时横幅
   *
   * @returns
   */
  isNtfKeyguard?(): boolean;

  /**
   * 是否为横幅通知
   *
   * @returns 通知类型
   */
  isHeadsUpNtf?(): boolean;
}