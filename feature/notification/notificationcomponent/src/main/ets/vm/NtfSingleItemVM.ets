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

import NtfSubscribe from '@ohos.notificationSubscribe';
import { NotificationEntry } from '../model/NotificationEntry';
import { NotificationType } from '../common/NotificationType';
import { ntfMgr, NotificationManager } from '../model/NotificationManager';
import { NotificationPanelManager } from '../model/NotificationPanelManager';
import NTF_LIST_VM_HOLDER from '../model/NtfListVmHolder';
import NtfListComponentVM from '../model/NtfListComponentVM';
import { NtfListVm } from '../model/NtfListVm';
import {
  APSSceneState,
  CardBorderRadius,
  ImmersiveSysEventUtils,
  NotificationWantAgentInfo,
  phoneAppMgr,
  SystemuiConstants,
  TimeoutPromise
} from '@ohos/systemuicommon';
import { StartType, LogDomain, LogHelper, CommonUtils, AnimateToScheduleUtils } from '@ohos/basicutils';
import {
  DeviceHelper,
  HiDfxEventUtil,
  HiSysDataNotifyClickState,
  ApsUtils,
  sSettingsUtil,
} from '@ohos/frameworkwrapper';
import { ResUtils, SCBSceneSessionManager, SCBScreenSessionManager } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { ScreenLockApi } from '@ohos/screenlockcommon/src/main/ets/api/ScreenLockApi';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { LiveUseScene } from '@ohos/systemuicommon';
import {
  DropDownPanelManager,
  liveStartAnimMgr,
  OverlayAnimData,
  OverlayAnimStepEnum,
  OverlayAnimExecutors,
  OverlayAnimGuarantee
} from '@ohos/systemuicommon/Index';
import { bannerMgr } from '@ohos/systemuicommon';
import { NotificationConstants } from '../common/NotificationConstants';
import { screenLockSysFloatTipControl } from '@ohos/screenlockcommon/src/main/ets/manager/SysFloatTipController';
import { NotificationSysEventReporter } from '@ohos/systemuicommon';
import {
  ScreenLockNotificationConst
} from '@ohos/screenlockcommon/src/main/ets/constants/ScreenLockNotificationConstants';
import { Callback } from '@kit.BasicServicesKit';
import wantAgent from '@ohos.app.ability.wantAgent';
import { CloseAppManager } from '@ohos/launchercommon/src/main/ets/manager/CloseAppManager';
import { NotificationUtils } from '../common/NotificationUtils';
import { ExclusiveChecker } from '../model/ExclusiveChecker';
import { NotificationConfig } from '../common/NotificationConfig';
import {
  ClickNotificationErrorCode,
  ClickNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/ClickNotificationMaintenance';
import {
  DeleteNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/DeleteNotificationMaintenance';
import { ClickRegion, DeleteNotificationType } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';
import { ntfViewConfigManager } from './config/NtfViewConfigManager';
import { PhoneNtfHeadsUpVm } from './phone/PhoneNtfHeadsUpVM';
import { NotificationUtil } from '@ohos/systemuicommon/src/main/ets/utils/NotificationUtil';

const TAG = 'NtfSingleItemVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const NO_LAUNCH_OPER_TYPES = [wantAgent.OperationType.UNKNOWN_TYPE, wantAgent.OperationType.SEND_COMMON_EVENT];
const UNLOCK_DELAY_TIME: number = 300;
const DELIVER_PRIVACY_ENABLE = 2;
const DISTRIBUTE_OPERATION_JUMP: number = 0;

/**
 * 单条通知数据处理
 *
 * @since 2023-01-07
 */
export class NtfSingleItemVM {
  /**
   * 组件回调器
   */
  private callback: SingleItemCallback | null = null;

  /**
   * 初始化
   *
   * @param callback 组件回调器
   */
  init(callback: SingleItemCallback): void {
    this.callback = callback;
  }

  /**
   * 销毁
   */
  onDestroy(): void {
    this.callback = null;
  }

  /**
   * 条目点击跳转
   *
   * @param isHeadsUp 是否横幅
   * @param clickCount 点击计数值
   * @param isKeyguardLock 是否在锁屏加锁状态
   */
  onItemClick(isHeadsUp?: boolean, clickCount?: number, isKeyguardLock?: boolean, isNtfKeyguard?: boolean): void {
    performanceMonitor.begin('NotificationClick', performanceMonitor.ActionType.LAST_UP);
    let entry = this.callback?.getNtfEntry();
    let privacyEnableState: number =
      Number(sSettingsUtil.getSystemValue(NotificationConstants.DELIVER_PRIVACY_ENABLE_STATE,
        NotificationConstants.DELIVER_PRIVACY_ENABLE_STATE_DEFAULT));
    let privacyScene: string = JSON.stringify({ 'privacyEnableState': privacyEnableState });
    ClickNotificationMaintenance.saveInfo({
      data: entry,
      clickRegion: isHeadsUp ? ClickRegion.BANNER_MAIN : ClickRegion.NTF_MAIN,
    });
    if (entry?.isDeliverNotification && privacyEnableState !== DELIVER_PRIVACY_ENABLE) {
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.DELIVER_PRIVACY_DISABLE, {
        clickRegion: ClickRegion.NTF_DELIVER,
        data: entry,
        scene: privacyScene,
      });
      log.showInfo(`onDeliverNtfClick, privacyEnableState = ${privacyEnableState}`);
    }
    if (!entry) {
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.NO_ENTRY);
      performanceMonitor.end('NotificationClick');
      return;
    }
    log.showInfo(`onItemClick  ${entry?.hashCode}  ${entry?.getGroupTypeKey()}  ${isKeyguardLock}  ${isNtfKeyguard}`);
    if (this.isExcludeForStartApp(entry)) {
      if (isHeadsUp) {
        this.releasePanel();
      } else {
        NotificationPanelManager.collapseNtfPanel(this.callback?.getNtfType() as number, true);
      }
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.DELIVER_EXCLUDE);
      return;
    }

    let reportNtf: NotificationEntry[] = entry.isGroup ? entry.childrenEntry! : [entry];

    if (entry?.isCollaNotification) {
      NotificationUtil.distributeOperation(entry?.hashCode, DISTRIBUTE_OPERATION_JUMP);
      log.showInfo(`doStartDistributeOperation for ${entry?.hashCode} finished`);
      return;
    }

    if (CommonUtils.isInvalid(entry?.wantAgent)) {
      this.onNoAgentClick(entry as NotificationEntry, isHeadsUp, isNtfKeyguard);
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.NO_WANTAGENT);
      performanceMonitor.end('NotificationClick');
      return;
    }

    const wantId: number = Reflect.get(entry.wantAgent, 'innerKey');
    log.showInfo(`onItemClick wantAgent: (${wantId})`);
    if (this.isKeyguard() || isNtfKeyguard) {
      let scene = this.getKgClickScene(isHeadsUp, isNtfKeyguard);
      performanceMonitor.end('NotificationClick');
      this.onKgItemClick(entry, clickCount, isKeyguardLock, isNtfKeyguard, scene);
    } else {
      performanceMonitor.end('NotificationClick');
      this.onOtherClick(entry, reportNtf, isHeadsUp);
    }
  }

  private getKgClickScene(isHeadsUp?: boolean, isNtfKeyguard?: boolean): LiveUseScene {
    if (isHeadsUp) {
      return LiveUseScene.SCENE_HEADS_UP;
    }
    if (isNtfKeyguard) {
      return LiveUseScene.SCENE_NTF_CENTER;
    }
    return LiveUseScene.SCENE_SCREEN_LOCK_NOTIFICATION;
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

  /**
   * 点击通知拉起应用
   * @param entry 通知entry条目
   * @param reportNtf 记录条目
   * @param isHeadsUp 是否横幅通知
   */
  private async onOtherClick(entry: NotificationEntry | null | undefined,
    reportNtf: NotificationEntry[], isHeadsUp?: boolean): Promise<void> {
    const pushIsDeliver = entry?.isDeliverPushNotification;
    let deliverStatus: boolean = false;
    if (entry?.isDeliverNotification) {
      deliverStatus = NotificationUtil.isDeliverNotStarted();
    }
    log.showInfo(`deliver status: ${deliverStatus}`)
    // 先执行拉起应用动作，减小应用启动时延
    this.startDoWantAgent(entry!, isHeadsUp ? LiveUseScene.SCENE_HEADS_UP : LiveUseScene.SCENE_NTF_CENTER);
    if (entry?.getLauncherBundleName()?.length !== 0) {
      performanceMonitor.begin('LAUNCHER_APP_LAUNCH_FROM_NOTIFICATIONBAR',
        performanceMonitor.ActionType.LAST_UP, entry?.creatorBundleName);
    }
    // 横幅拉起应用场景控帧，具体帧率由HGM根据负载情况计算：begin
    // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, APSSceneState.START_SCENE);

    let isMidScene = this.callback?.getIsMidScene ? this.callback?.getIsMidScene() : false;
    HiDfxEventUtil.reportNotifyItemClick(entry!.creatorBundleName, HiSysDataNotifyClickState.UNLOCK_SINGLE_CLICK);
    NotificationSysEventReporter.notificationClickApp({
      DISPLAY_SCENE: this.isKeyguard() ? 2 : isHeadsUp ? 3 : 4,
      CREATOR_BUNDLE_NAME: entry?.creatorBundleName,
      IS_LIVE: entry?.isLiveType() ? 0 : 1,
      NOTIFICATION_ID: entry?.id,
      NOTIFICATION_SLOT_TYPE: entry?.slotType,
      TIME_STAMP: NotificationUtils.getNtfTimeStampByBoard(this.isKeyguard()),
      IS_IN_GROUP: this.isInGroup() ? 1 : 0,
      IS_IN_AGGREGATE: this.isInAggregate() ? 1 : 0,
      IS_MIDSCENE: isMidScene ? 1 : 0,
      NOTIFICATION_CONTROL_FLAGS: entry?.controlConfig?.flags,
      USER_ID: entry?.creatorUserId,
      HASHCODE: entry?.hashCode,
      BUNDLE_TYPE: entry?.bundleType,
      TRACE_ID: entry?.traceId
    });
  }

  /**
   * 当点击通知没有wantAgent时
   * @param entry 通知entry条目
   * @param isHeadsUp 是否横幅通知
   */
  private onNoAgentClick(entry: NotificationEntry, isHeadsUp?: boolean, isNtfKeyguard?: boolean) {
    log.showInfo('onItemClick this ntf has not click agent.');
    if (this.isKeyguard() || isNtfKeyguard) {
      HiDfxEventUtil.reportNotifyItemClick(entry!.creatorBundleName, HiSysDataNotifyClickState.LOCK_SINGLE_CLICK);
      let componentId: string = isNtfKeyguard ?
        isHeadsUp ? ScreenLockNotificationConst.NTF_OUT_HEADS_UP_KEY_GUARD_TIP :
          ScreenLockNotificationConst.NTF_OUT_DROPDOWN_PANEL_KEY_GUARD_TIP :
        ScreenLockNotificationConst.NTF_KEY_GUARD_TIP;
      screenLockSysFloatTipControl.setTipMessage(componentId,
        ResUtils.getInnerStringByName('ntf_keyguard_no_content_click_tip'));
      screenLockSysFloatTipControl.setFloatTipDialogVisible(componentId, true,
        ScreenLockNotificationConst.CLICK_TOAST_SHOW_DURATION);
    } else {
      HiDfxEventUtil.reportNotifyItemClick(entry!.creatorBundleName, HiSysDataNotifyClickState.UNLOCK_SINGLE_CLICK);
    }
    let isMidScene = this.callback?.getIsMidScene ? this.callback?.getIsMidScene() : 0
    NotificationSysEventReporter.notificationClickApp({
      DISPLAY_SCENE: this.isKeyguard() ? 2 : isHeadsUp ? 3 : 4,
      CREATOR_BUNDLE_NAME: entry?.creatorBundleName,
      IS_LIVE: entry?.isLiveType() ? 0 : 1,
      NOTIFICATION_ID: entry?.id,
      NOTIFICATION_SLOT_TYPE: entry?.slotType,
      TIME_STAMP: NotificationUtils.getNtfTimeStampByBoard(this.isKeyguard()),
      IS_IN_GROUP: this.isInGroup() ? 1 : 0,
      IS_IN_AGGREGATE: this.isInAggregate() ? 1 : 0,
      IS_MIDSCENE: isMidScene ? 1 : 0,
      NOTIFICATION_CONTROL_FLAGS: entry?.controlConfig?.flags,
      USER_ID: entry.creatorUid,
      HASHCODE: entry.hashCode,
      TRACE_ID: entry?.traceId,
      BUNDLE_TYPE: entry.bundleType,
    });
  }

  /**
   * 锁屏场景条目点击跳转
   *
   * @param entry 通知entry条目
   * @param clickCount 点击计数值
   * @param isKeyguardLock 是否是锁屏加锁状态
   * @param isNtfKeyguard 是否是锁屏上的通知中心或临时横幅
   * @param scene 锁屏通知场景  横幅 锁屏通知列表  通知中心
   */
  private onKgItemClick(entry: NotificationEntry | null | undefined, clickCount: number | undefined,
    isKeyguardLock: boolean | undefined, isNtfKeyguard?: boolean, scene?: LiveUseScene): void {
    if (CommonUtils.isInvalid(entry)) {
      return;
    }
    // 锁屏面板未解锁时 单击提示, 双击申请解锁跳转; 解锁后单击直接打开
    let isLocked = isKeyguardLock ?? false;
    let isGroup = this.isInGroup();
    let componentId: string = this.getTipComponentId(isNtfKeyguard, scene === LiveUseScene.SCENE_HEADS_UP);
    if (clickCount === ScreenLockNotificationConst.NTF_FIRST_CLICK && isLocked && !isGroup) {
      let rebootNtf: boolean = AppStorage.get<boolean>('reboot_ntf_msg') ?? false
      HiDfxEventUtil.reportNotifyItemClick(entry!.creatorBundleName, HiSysDataNotifyClickState.LOCK_SINGLE_CLICK);
      let tipName = rebootNtf ? ScreenLockNotificationConst.KG_NTF_NO_CONTENT_TIP : ScreenLockNotificationConst.KG_NTF_CLICK_TIP;
      screenLockSysFloatTipControl.setTipMessage(componentId, ResUtils.getInnerStringByName(tipName));
      screenLockSysFloatTipControl.setFloatTipDialogVisible(componentId, true,
        ScreenLockNotificationConst.CLICK_TOAST_SHOW_DURATION);
    } else if (clickCount === ScreenLockNotificationConst.NTF_SECOND_CLICK || !isLocked || isGroup) {
      screenLockSysFloatTipControl.setFloatTipDialogVisible(componentId, false);
      HiDfxEventUtil.reportNotifyItemClick(entry!.creatorBundleName, HiSysDataNotifyClickState.LOCK_DOUBLE_CLICK);
      if (entry?.isLiveType()) {
        ImmersiveSysEventUtils.reportClickToAppEvent(entry?.liveViewData);
      } else {
        NotificationSysEventReporter.notificationClickApp({
          DISPLAY_SCENE: 2,
          CREATOR_BUNDLE_NAME: entry?.creatorBundleName,
          IS_LIVE: entry?.isLiveType() ? 0 : 1,
          NOTIFICATION_ID: entry?.id,
          NOTIFICATION_SLOT_TYPE: entry?.slotType,
          NOTIFICATION_CONTROL_FLAGS: entry?.controlConfig?.flags,
          TRACE_ID: entry?.traceId,
          BUNDLE_TYPE: entry?.bundleType,
        });
      }
      performanceMonitor.begin('LAUNCHER_APP_LAUNCH_FROM_NOTIFICATIONBAR_IN_LOCKSCREEN',
        performanceMonitor.ActionType.LAST_UP, entry?.creatorBundleName);
      this.startAgentOnLock(isLocked, entry, isNtfKeyguard, scene);
    }
  }

  private getTipComponentId(isNtfKeyguard?: boolean, isHeadsUp?: boolean): string {
    if (!isNtfKeyguard) {
      return ScreenLockNotificationConst.NTF_KEY_GUARD_TIP;
    }
    return isHeadsUp ? ScreenLockNotificationConst.NTF_OUT_HEADS_UP_KEY_GUARD_TIP :
      ScreenLockNotificationConst.NTF_OUT_DROPDOWN_PANEL_KEY_GUARD_TIP;
  }

  startAgentOnLock(isLocked: boolean, entry: NotificationEntry | null | undefined,
    isNtfKeyguard?: boolean, scene?: LiveUseScene) {
    log.showInfo(`startAgentOnLock  ${isLocked} ${this.isKeyguard()} ${isNtfKeyguard} ${scene}`);
    if (AppStorage.get<boolean>('reboot_ntf_msg') ?? false) {
      let componentId: string = ScreenLockNotificationConst.NTF_KEY_GUARD_TIP;
      screenLockSysFloatTipControl.setTipMessage(componentId,
        ResUtils.getInnerStringByName('ntf_keyguard_no_content_click_tip'));
      screenLockSysFloatTipControl.setFloatTipDialogVisible(componentId, true,
        ScreenLockNotificationConst.CLICK_TOAST_SHOW_DURATION);
      return;
    }
    if (isLocked) {
      ScreenLockApi.requestUnlock({
        authResultSuccess: (): void => {
          this.startDoWantAgent(entry as NotificationEntry,
            LiveUseScene.SCENE_SCREEN_LOCK,
            (data) => {
              performanceMonitor.end('LAUNCHER_APP_LAUNCH_FROM_NOTIFICATIONBAR_IN_LOCKSCREEN');
            })
        }
      });
      return;
    }
    ScreenLockApi.notifyEarlyUnlockTransition();
    let currentScene = scene ?? LiveUseScene.SCENE_SCREEN_LOCK_NOTIFICATION;
    this.startDoWantAgent(entry as NotificationEntry,
      currentScene,
      (data) => {
        performanceMonitor.end('LAUNCHER_APP_LAUNCH_FROM_NOTIFICATIONBAR_IN_LOCKSCREEN');
      },
      isNtfKeyguard
    );
    // 锁屏通知列表场景延时解锁
    if (currentScene === LiveUseScene.SCENE_SCREEN_LOCK_NOTIFICATION) {
      setTimeout(() => {
        ScreenLockApi.requestUnlock(undefined);
      }, UNLOCK_DELAY_TIME);
    } else {
      ScreenLockApi.requestUnlock(undefined);
    }
  }

  /**
   * 是否为锁屏面板
   *
   * @return true 锁屏面板
   */
  isKeyguard(): boolean {
    return NotificationType.isKeyguard(this.callback?.getNtfType() as number);
  }

  /**
   * 移除超时任务
   */
  private checkClearRunnable(runnableId: number | undefined): number | undefined {
    if (CommonUtils.isInvalid(runnableId)) {
      return;
    }
    clearTimeout(runnableId);
    return undefined;
  }

  /**
   * 开始跳转
   *
   * @param entry 通知数据
   * @param scene 卡片使用场景
   */
  private startDoWantAgent = (entry: NotificationEntry, scene: LiveUseScene, callback?: Callback<number>,
    isNtfKeyguard?: boolean): void => {
    log.showInfo(`startDoWantAgent ${entry?.hashCode}  ${entry?.isLiveType()}  ${scene}  ${isNtfKeyguard}`);
    const alreadyNotifyCollapse = this.handleNtfPanelCollapse(entry);
    // 启动agent
    let startAgent = (hasAnim: boolean = true, beforeRemoveHandler?: () => void, isForeground: boolean = false) => {
      log.showInfo(`enter startAgent`);
      // 跳转agent
      CloseAppManager.getInstance().setStartAppType(StartType.APP);
      let isMidScene = this.callback?.getIsMidScene ? this.callback?.getIsMidScene() : false;
      this.checkWantAgent(entry.wantAgentInfo);
      let callbackForInvokeCallbackAndRemoveNotification = (data: number) => {
        if (callback) {
          try {
            callback(data);
          } catch (error) {
            log.error(`invoke callback occ error:`, error);
          }
        }
        this.removeNotification(entry, scene, beforeRemoveHandler);
      };

      let startAction = () => {
        if (scene === LiveUseScene.SCENE_HEADS_UP && isMidScene) {
          ntfMgr.startMidSceneAgent(entry, callbackForInvokeCallbackAndRemoveNotification);
        } else {
          ntfMgr.startWantAgent(entry.wantAgent!, callbackForInvokeCallbackAndRemoveNotification, undefined, undefined,
            entry);
        }
      };

      startAction();

      // 横幅点击，收起横幅面板
      if (scene === LiveUseScene.SCENE_HEADS_UP) {
        if (isForeground && this.callback?.getHeadsUpVm) {
          this.callback.getHeadsUpVm().hideHeadsUpWindow();
          return;
        }
        // 中景窗模式有淡出动效，动效结束后收起面板
        let duration = isMidScene ? 200 : 50
        if (hasAnim || isMidScene) {
          // 当存在拉起动效时延迟几帧关闭横幅让卡片缩小动效和拉起窗口动效有衔接
          setTimeout(() => {
            this.releasePanel();
          }, duration);
          return;
        }

        this.releasePanel();
      }
    };

    this.checkDropdownRotateEnable(scene);
    if (scene === LiveUseScene.SCENE_SCREEN_LOCK_NOTIFICATION && entry.getLauncherBundleName()) {
      liveStartAnimMgr.startAnimPre({
        cardId: entry.hashCode,
        startBundleName: entry.getLauncherBundleName(),
        cardComponentId: this.getComponentId(entry, LiveUseScene.SCENE_NTF_CENTER),
        cardRadius: entry.groupEntry?.isGroup ? this.getGroupItemRadius() : this.getLiveAnimPreRadius(),
        scene: scene,
        onPreComplete: startAgent,
        onAnimComplete: () => {
          if (entry.isAutoDelete) {
            ntfMgr.removeNotificationByClick(entry);
          }
        }
      });
    } else if (entry.isDeliverNotification) {
      startAgent(false);
    } else if (entry.isLiveType()) {
      if (scene === LiveUseScene.SCENE_NTF_CENTER) {
        OverlayAnimExecutors.getLastOrCreateExecutor().init([NtfListComponentVM.overlayAnimData]);
      }
      liveStartAnimMgr.startAnimPre({
        cardId: entry.hashCode,
        startBundleName: entry.getLauncherBundleName(),
        scene: scene,
        onPreComplete: startAgent,
        isLockScreen: isNtfKeyguard
      });
    } else if (scene === LiveUseScene.SCENE_NTF_CENTER) {
      // deliverPush场景直接拉起
      if (entry?.isDeliverPushNotification || ntfViewConfigManager.getListContentConfig().isNtfStartDirectly) {
        startAgent(true);
      } else {
        const preAction =
          (ntfCenterVm: NtfListVm): void => startAgent(true, () => ntfCenterVm?.setUpdateFreeze('OverlayAnim'))
        this.startAnimPreForNtfCenter(entry, scene, preAction, isNtfKeyguard, alreadyNotifyCollapse);
      }
    } else if (scene === LiveUseScene.SCENE_HEADS_UP) {
      const isTargetAppForeground =
        NotificationUtil.isTargetAppForeground(entry.creatorBundleName, entry.appIndex, entry.wantAgentInfo.want);
      log.showWarn('heads up clicked, isTargetAppForeground:%{public}s', isTargetAppForeground);
      if (isTargetAppForeground) {
        startAgent(true, undefined, true);
        return;
      }
      liveStartAnimMgr.startAnimPre({
        cardId: entry.hashCode,
        startBundleName: entry.getLauncherBundleName(),
        cardComponentId: this.getCardComponentId(scene, entry),
        scene: scene,
        onPreComplete: startAgent,
        isLockScreen: isNtfKeyguard
      });
    } else {
      // 锁屏通知，直接启动
      startAgent(false);
    }
  }

  private startAnimPreForNtfCenter(entry: NotificationEntry, scene: LiveUseScene,
    preAction: (ntfCenterVm: NtfListVm) => void, isNtfKeyguard?: boolean, alreadyNotifyCollapse?: boolean) {
    const ntfCenterVm = NTF_LIST_VM_HOLDER.getNtfListVmInstance(NotificationType.TYPE_PHONE_DROPDOWN);
    this.setNtfCenterOverlayAnim(ntfCenterVm);
    liveStartAnimMgr.startAnimPre({
      cardId: entry.hashCode,
      startBundleName: entry.getLauncherBundleName(),
      cardComponentId: this.getCardComponentId(scene, entry),
      scene: scene,
      onPreComplete: () => preAction(ntfCenterVm),
      isNeedCollapseDropdownPanel: !alreadyNotifyCollapse,
      isLockScreen: isNtfKeyguard
    });
  }

  // 从通知中心点击通知卡片拉起应用时需关闭旋转锁定，防止拉起的应用方向不对
  private checkDropdownRotateEnable(scene: LiveUseScene) {
    if (scene === LiveUseScene.SCENE_NTF_CENTER) {
      const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
      screenSession?.setEnableRotate(true, WindowConstants.WINDOW_NAME_DROPDOWN);
    }
  }

  private checkWantAgent(wantAgentInfo: NotificationWantAgentInfo | undefined): void {
    if (!wantAgentInfo || !wantAgentInfo.want || !wantAgentInfo.operationType || !wantAgentInfo.bundleName) {
      ClickNotificationMaintenance.updateErrorCode(ClickNotificationErrorCode.INVALID_WANTAGENT);
    }
  }

  private getComponentId(entry: NotificationEntry, scene: LiveUseScene): string | undefined {
    if (entry.isLiveType()) {
      return undefined;
    }
    return NotificationConstants.isGroupNTF(entry) ?
      NotificationConstants.getGroupNTFItemCompId(entry.getGroupKey()) :
      NotificationConstants.getNTFSingleItemCompId(scene, entry.hashCode)
  }

  private getGroupItemRadius(): CardBorderRadius | undefined {
    return {
      topLeft: NotificationConfig.BORDER_RADIUS,
      topRight: NotificationConfig.BORDER_RADIUS,
      bottomLeft: NotificationConfig.BORDER_RADIUS,
      bottomRight: NotificationConfig.BORDER_RADIUS
    }
  }

  public getCardComponentId = (scene: LiveUseScene, entry: NotificationEntry) => {
    if (scene === LiveUseScene.SCENE_NTF_CENTER && this.callback?.getIsInGroup?.()) {
      return NotificationConstants.getGroupNTFItemCompId(entry.getGroupTypeKey());
    } else {
      return NotificationConstants.getNTFSingleItemCompId(scene, entry.hashCode);
    }
  }
  public setNtfCenterOverlayAnim = (ntfCenterVm?: NtfListVm, isNeedCollapseDropdownPanel: boolean = true) => {
    const groupTypeKey = this.callback?.getNtfEntry()?.getGroupTypeKey() ?? '';

    const overlayAnimExecutor = OverlayAnimExecutors.getLastOrCreateExecutor();
    overlayAnimExecutor.init(this.getAnimData());
    if (ntfCenterVm) {
      overlayAnimExecutor.addBeforeHandler(() => {
        AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);
        ntfCenterVm.raiseItemToTop(groupTypeKey);
      }, 'beforeHandler');
      overlayAnimExecutor.addAfterHandler(() => {
        AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
        ntfCenterVm.refreshItemZIndex;
        if (isNeedCollapseDropdownPanel) {
          ntfCenterVm.releaseUpdateFreeze('OverlayAnim')
        }
      }, 'afterHandler');
      overlayAnimExecutor.setContainerRect(ntfCenterVm.listContainerRect)
    }

    overlayAnimExecutor.addAnimation(OverlayAnimStepEnum.SCENE_LAYOUT, (animData) => {
      animData.ntfPanelScale = 0.9;
      animData.ntfPanelOpacity = 0;
    }, 'DismissNtfPanel');
  }

  /**
   * 组通知的一镜到底是整个组通知作为一个整体，里面的单个通知不变化
   */
  private getAnimData(): OverlayAnimData[] {
    const result = [...this.callback?.getAncestorsOverlayAnimData?.() ?? []];
    result.push(NtfListComponentVM.overlayAnimData);
    if (!this.callback?.getIsInGroup?.()) {
      const anim = this.callback?.getOverlayAnimData?.();
      anim && result.push(anim);
    }
    return result;
  }

  /**
   * 处理面板收起逻辑
   * 1. NO_LAUNCH_OPER_TYPES 或 pc，不做一镜到底，直接动画收起面板
   * 2. LAUNCH_OPER_TYPES 确定会启动应用，此处不收起面板，由一镜到底动画收起
   * 3. 其他场景(如:START_SERVICE)，可能会启动应用做一镜到底，注入保底逻辑
   *
   * @param entry 通知
   * @returns 是否下发面板收起逻辑
   */
  private handleNtfPanelCollapse(entry: NotificationEntry): boolean {
    const type = this.callback?.getNtfType() as number;
    return this.handleNtfPanelCollapseByWant(entry, type, entry.wantAgentInfo?.operationType);
  }

  public handleNtfPanelCollapseByWant = (entry: NotificationEntry, ntfType?: number, operType?: number) => {
    const isPc = DeviceHelper.isPC();
    log.showInfo('HandleNtfPanelCollapseByWant. %{public}d %{public}s %{public}d', operType, isPc, ntfType);

    if (operType === undefined || NO_LAUNCH_OPER_TYPES.includes(operType) || isPc) {
      liveStartAnimMgr.resetMoveDown();
      NotificationPanelManager.collapseNtfPanel(ntfType ?? NotificationType.TYPE_PHONE_DROPDOWN, true);
      return true;
    } else {
      const executor = OverlayAnimExecutors.getLastOrCreateExecutor();
      OverlayAnimGuarantee.init(entry.hashCode, new TimeoutPromise<void>(entry.hashCode)
        .addThenCallback(DropDownPanelManager.hideWindowDirectly)
        .addThenCallback(() => OverlayAnimExecutors.safeRemove(executor)));
      return false;
    }
  }

  private releasePanel() {
    if (this.callback?.notifyNtfEntryChange) {
      this.callback.notifyNtfEntryChange(null);
    }
    bannerMgr.releasePanelHeadsUp();
  }

  private getLiveAnimPreRadius(): CardBorderRadius | undefined {
    if (this.callback?.getIsInGroup && this.callback?.getIsInGroup()) {
      if (this.callback?.getIsLastInGroup && this.callback?.getIsLastInGroup()) {
        return {
          topLeft: 0,
          topRight: 0,
          bottomLeft: NotificationConfig.BORDER_RADIUS,
          bottomRight: NotificationConfig.BORDER_RADIUS
        }
      }
      return {
        topLeft: 0,
        topRight: 0,
        bottomLeft: 0,
        bottomRight: 0
      }
    }
    return undefined;
  }

  /**
   * 判断是否为分组中的条目
   *
   * @returns 是否为分组中的条目
   */
  isInGroup(): boolean {
    return (this.callback?.getIsInGroup && this.callback?.getIsInGroup()) ?? false;
  }

  /**
   * 判断是否为聚合通知中的条目
   * @returns 是否为聚合通知中的条目
   */
  isInAggregate(): boolean {
    return (this.callback?.getIsInAggregate && this.callback?.getIsInAggregate()) ?? false;
  }

  /**
   * 锁屏点击带按钮通知时提醒处理
   *
   * @param clickCount 点击计数值
   * @param isKeyguardLock 是否锁屏加锁状态
   * @returns 是否发出弹窗提醒
   */
  kgDisplayButtonClickTip(clickCount: number, isKeyguardLock: boolean, isHideNtfContent: boolean,
    isNtfKeyguard?: boolean): boolean {
    let componentId: string = isNtfKeyguard ? ScreenLockNotificationConst.NTF_OUT_DROPDOWN_PANEL_KEY_GUARD_TIP :
      ScreenLockNotificationConst.NTF_KEY_GUARD_TIP;
    if (clickCount === ScreenLockNotificationConst.NTF_FIRST_CLICK && isKeyguardLock) {
      // 隐藏通知不提示双击展开通知
      if (!isHideNtfContent) {
        screenLockSysFloatTipControl.setTipMessage(componentId,
          ResUtils.getInnerStringByName(ScreenLockNotificationConst.DOUBLE_CLICK_EXPAND_TIP));
        screenLockSysFloatTipControl.setFloatTipDialogVisible(componentId, true,
          ScreenLockNotificationConst.CLICK_TOAST_SHOW_DURATION);
      }
      return true;
    }
    screenLockSysFloatTipControl.setFloatTipDialogVisible(componentId, false);
    return false;
  }

  /**
   * 删除通知
   * @param entry
   * @param scene
   * @param beforeRemoveHandler
   */
  private removeNotification(entry: NotificationEntry, scene: LiveUseScene,
    beforeRemoveHandler?: Callback<void>): void {
    // 自动取消
    let canBeRemove =
      entry.isAutoDelete && (scene != LiveUseScene.SCENE_SCREEN_LOCK_NOTIFICATION || !entry.getLauncherBundleName());
    if (!canBeRemove) {
      return;
    }
    beforeRemoveHandler?.();
    DeleteNotificationMaintenance.addNtfMap([entry], DeleteNotificationType.NOTIFICATION_CLICK_DELETE,
      this.callback?.getIsInGroup && this.callback?.getIsInGroup());
    if (AppProtectedVm.get().isProtected(entry.bundleIdxTag) && this.callback?.getGroupEntry) {
      const groupEntry = this.callback.getGroupEntry();
      if (groupEntry?.childrenEntry) {
        ntfMgr.batchRemoveNtf(groupEntry.childrenEntry, NtfSubscribe.RemoveReason.CLICK_REASON_REMOVE);
      } else {
        log.showWarn('Group invalid, Delete single entry.');
        ntfMgr.removeNotificationByClick(entry);
      }
    } else {
      ntfMgr.removeNotificationByClick(entry);
    }
  }
}

/**
 * 组件回调器
 */
export interface SingleItemCallback {
  /**
   * 获取通知数据
   *
   * @return 通知数据
   */
  getNtfEntry(): NotificationEntry | null;

  /**
   * 获取所在的组通知
   */
  getGroupEntry?(): NotificationEntry | undefined;

  /**
   * 获取通知面板类型
   *
   * @return 通知面板类型
   */
  getNtfType(): number;

  /**
   * 判断是否为分组中的条目
   *
   * @returns 是否为分组中的条目
   */
  getIsInGroup?(): boolean;

  /**
   * 判断是否处于应用锁保护态
   *
   * @returns
   */
  getIsProtected?(): boolean;

  /**
   * 判断是否为聚合通知中的条目
   *
   * @returns
   */
  getIsInAggregate?(): boolean;

  /**
   * 判断是否为分组中的最后一个条目
   *
   * @returns 是否为分组中的最后一个条目
   */
  getIsLastInGroup?(): boolean;

  /**
   * 判断是否是中景窗状态
   */
  getIsMidScene?(): boolean;

  /**
   * 设置通知数据
   *
   * @param ntfEntry 通知数据
   */
  notifyNtfEntryChange?(ntfEntry: NotificationEntry | null): void;

  /**
   * 获取一镜到底动效状态变量
   *
   * @returns 状态变量
   */
  getOverlayAnimData?(): OverlayAnimData;

  /**
   * 获取祖先一镜到底状态变量
   *
   * @returns 状态变量
   */
  getAncestorsOverlayAnimData?(): OverlayAnimData[];

  /**
   * 获取横幅Vm
   *
   * @returns
   */
  getHeadsUpVm?(): PhoneNtfHeadsUpVm;
}