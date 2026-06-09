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

import { performanceMonitor } from '@kit.ArkUI';
import { NotificationApiUtil } from '../utils/NotificationApiUtil';
import {
  AnimationBase,
  DeviceInfoVm,
  DropdownVm,
  EnvVm,
  INotificationCardVm,
  INotificationStarterVm,
  NotificationBaseVm,
  NotificationStartWantAgentParams,
  StartAppOneMirrorAnimation } from '@ohos/systemuicommon/newIndex';
import { NotificationSysEventReporter,
  StatusBarType,
  ScreenLockAdapter,
  SystemUICommonUtil,
  SystemuiConstants } from '@ohos/systemuicommon';
import { ExclusiveChecker } from '../model/ExclusiveChecker';
import { NotificationConfig } from '../common/NotificationConfig';
import { NotificationBase, NotificationUtil } from '@ohos/systemuicommon/newTsIndex';
import {
  ClickNotificationErrorCode,
  ClickNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/ClickNotificationMaintenance';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { DeviceHelper, HiDfxEventUtil, HiSysDataNotifyClickState } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ArkUIAdapter, ViewName } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { WantAgentUtil } from '@ohos/systemuicommon/src/main/ets/utils/WantAgentUtil';
import { LiveStyle } from '@ohos/systemuicommon/src/main/ets/live/constants/LiveStyle';
import { NotificationStatusBarEventManager } from '../manager/NotificationStatusBarEventManager';
import { SCBSceneMode } from '@ohos/windowscene';
import { StatusBarManager } from '@ohos/systemuicommon/src/main/ets/statusbar/manager/StatusBarManager';
import { NotificationType } from '../common/NotificationType';
import { sharedData } from '@ohos/systemuicommon/Index';

const TAG = 'NotificationStarterVm';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);
const DISTRIBUTE_OPERATION_JUMP: number = 0;
const DISTRIBUTE_OPERATION_BUTTON: number = 1;
const MID_SCENE_NOTIFICATION = 'midSceneNotification';

export class NotificationStarterVm extends NotificationBaseVm implements INotificationStarterVm {
  private startCardAnimation = new AnimationBase(AnimationBase.NAMES.NTF_OVERLAY_ANIMATION);

  async startWantAgent(params: NotificationStartWantAgentParams): Promise<void> {
    // 是否为全场景协同通知
    if (params.cardVm.ntf.isCollaNotification) {
      await this.doStartDistributeOperation(params);
      this.hidePanel(true);
      return;
    }
    await this.doStartWantAgent(params);
  }

  // 执行全场景协同通知
  protected async doStartDistributeOperation(params: NotificationStartWantAgentParams): Promise<void> {
    const clickInfo = ClickNotificationMaintenance.getInfo();

    try {
      log.showInfo(`doStartDistributeOperation for ${params.cardVm.ntf.hashCode} start`);
      await NotificationUtil.distributeOperation(params.cardVm.ntf.hashCode,
        params.operationInfo ? DISTRIBUTE_OPERATION_BUTTON :
          params.cardVm.ntf.isLiveView() ? LiveStyle.DISTRIBUTE_OPERATION_CARD_JUMP : DISTRIBUTE_OPERATION_JUMP,
        params.operationInfo?.buttonIndex, params.operationInfo?.actionName, params.triggerInfo?.extraInfo?.data);
      log.showInfo(`doStartDistributeOperation for ${params.cardVm.ntf.hashCode} finished`);
      ClickNotificationMaintenance.reportClick(undefined, clickInfo);
    } catch (e) {
      log.showError(`doStartDistributeOperation for ${params.cardVm.ntf.hashCode} error:`, e);
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.TRIGGER_WANTAGENT_FAIL, clickInfo, e);
    }
  }

  protected async doStartWantAgent(params: NotificationStartWantAgentParams): Promise<void> {
    const ntf: NotificationBase = params.cardVm.ntf;
    if (!this.beforeStartWantAgent(params)) {
      return;
    }
    log.showInfo(`Start wantAgent for ${params.cardVm.ntf.hashCode}`);
    const clickInfo = ClickNotificationMaintenance.getInfo();
    try {
      const componentId = params.groupCardVm?.componentId ?? params.cardVm.componentId;
      const agentInfo = params.wantAgentInfo ?? await WantAgentUtil.parseWantAgentInfo(params.wantAgent);
      const launcherBundleName = WantAgentUtil.getLauncherBundleName(params.cardVm.ntf, agentInfo);
      log.showInfo(`AgentInfo bundle: ${agentInfo?.bundleName}, operationType: ${agentInfo?.operationType}, ` +
        `isPC: ${DeviceHelper.isPC()}, ntfType: ${NotificationType.TYPE_PHONE_DROPDOWN}`);
      if (!agentInfo || !agentInfo.want || !agentInfo.operationType || !agentInfo.bundleName) {
        ClickNotificationMaintenance.updateErrorCode(ClickNotificationErrorCode.INVALID_WANTAGENT);
      }
      params.wantAgentInfo = agentInfo;
      this.setLaunchReasonFromNC(params);
      log.showInfo(`launch bundle: ${launcherBundleName}, operationType: ${agentInfo?.operationType}`);
      if (agentInfo && WantAgentUtil.isStartApp(agentInfo) && this.isStartAppByOneMirror(params)) {
        log.showInfo(`Start app for card ${componentId}`);
        const cardRect = this.getAnimationCardRect(componentId);
        // 通知中心下拉场景，更新一镜到底动效执行中为true, 其它场景不需要
        if (this.vmInjector.viewName === ViewName.DROPDOWN_VIEW) {
          DropdownVm.instance.oneMirrorAnimating = true;
        }
        this.setMidSceneParam(params);
        NotificationApiUtil.setRotateEnabled(true);
        this.postStateBarIconEvent(params);
        // 面板只需要收起一次, 避免多次收起面板
        let isHidePanelExecuted = false;
        const promise = StartAppOneMirrorAnimation.instance.prepare({
          scene: this.vmInjector.scene,
          cardRect: cardRect,
          cardRadius: NotificationConfig.BORDER_RADIUS,
          bundleName: launcherBundleName,
          onExecute: () => {
            // 执行一镜到底动效, 在onExecute中会收起面板
            isHidePanelExecuted = true;
            this.onExecute(params.groupCardVm ?? params.cardVm, cardRect);
          },
        }).then(() => {
          this.afterStartWantAgent(params, !isHidePanelExecuted);
          isHidePanelExecuted = true;
          // 通知中心下拉场景，更新一镜到底动效执行中为false, 其它场景不需要
          if (this.vmInjector.viewName === ViewName.DROPDOWN_VIEW) {
            DropdownVm.instance.oneMirrorAnimating = false;
          }
        });
        const result = await Promise.all([promise, WantAgentUtil.startWantAgent(params.wantAgent,
          params.triggerInfo)]);
        const isStartSuccess = result[1];
        if (!isStartSuccess && !isHidePanelExecuted) {
          // wantAgent拉起失败时也要收面板，避免状态残留背板变黑
          this.hidePanel();
        }
        ClickNotificationMaintenance.reportClickWithResult(isStartSuccess,
          ClickNotificationErrorCode.TRIGGER_WANTAGENT_FAIL, clickInfo);
      } else {
        const isSuccess: boolean = await WantAgentUtil.startWantAgent(params.wantAgent, params.triggerInfo);
        ClickNotificationMaintenance.reportClickWithResult(isSuccess, ClickNotificationErrorCode.TRIGGER_WANTAGENT_FAIL,
          clickInfo);
        // 点击按钮没有拉起应用则不收起通知中心，其他场景都收起
        const isHidePanel = params.operationInfo?.buttonIndex === undefined;
        this.afterStartWantAgent(params, isHidePanel);
      }
    } catch (e) {
      log.error(`Start wantAgent for ${params.cardVm.ntf.hashCode} error:`, e);
      ClickNotificationMaintenance.reportClickWithResult(false, ClickNotificationErrorCode.TRIGGER_WANTAGENT_FAIL,
        clickInfo);
    }
  }

  private setMidSceneParam(params: NotificationStartWantAgentParams) {
    if (this.vmInjector.viewName !== ViewName.BANNER_VIEW) {
      return;
    }
    const isMidScene = this.vmInjector.getBannerVm()?.isMidScene;
    log.showInfo(`setMidSceneParam. isMidScene: ${isMidScene}`)
    if (isMidScene && params.wantAgentInfo?.want?.parameters) {
      params.wantAgentInfo.want.parameters[MID_SCENE_NOTIFICATION] = isMidScene;
      // 中景窗windowModel也使用FLOATING
      params.triggerInfo.startOptions = { windowMode: SCBSceneMode.FLOATING }
    }
  }

  /**
   * 获取一镜到底动效卡片的位置和尺寸
   */
  private getAnimationCardRect(componentId: string): RectResult {
    let cardRect =
      SystemUICommonUtil.getRect(componentId, ArkUIAdapter.getUiContextByViewName(this.vmInjector.viewName));

    // 下拉面板需要处理滑动超出屏幕的场景，继续裁切一下避免被屏幕截断。
    if (this.vmInjector.viewName === ViewName.DROPDOWN_VIEW) {
      cardRect = this.vmInjector.getListScrollerVm()?.getOneMirrorCardClipRect(cardRect) ?? cardRect;
    }
    return cardRect;
  }

  postStateBarIconEvent(params: NotificationStartWantAgentParams): void {
    if (params.cardVm.ntf.isAutoDelete) {
      NotificationStatusBarEventManager.get().postStateBarIconEventByStarter(params.cardVm.ntf);
    }
  }

  isStartAppByOneMirror(params: NotificationStartWantAgentParams): boolean {
    return true;
  }

  async onExecute(cardVm: INotificationCardVm, cardRect: RectResult): Promise<void> {
    log.showInfo(`Execute start app animation for ${cardVm.ntf.hashCode} begin`);
    // 执行一镜到底前，先修改状态栏类型，执行状态栏下沉恢复动效
    StatusBarManager.getInstance()?.setStatusBarType(EnvVm.instance.isLockAndNotEditor()
      ? StatusBarType.TYPE_MAIN_PHONE_KEYGUARD : StatusBarType.TYPE_MAIN_PHONE_LAUNCHER);
    if (sharedData.isDropDownShow) {
      log.showInfo(`setDropdownOnly true`);
      DropdownVm.instance.setDropdownOnly(true);
    }
    log.showInfo(`Execute start app animation for ${cardVm.ntf.hashCode} begin`);

    // 动效开始前设置参数
    this.startCardAnimation.setInitialState(() => {
      cardVm.containerSize = { width: cardRect.width, height: cardRect.height };
      cardVm.align = Alignment.Center;
    });

    // 通知中心下拉场景, 需要将面板提前设置为透明, 其它场景不需要
    if (this.vmInjector.viewName === ViewName.DROPDOWN_VIEW) {
      setTimeout(() => {
        log.showWarn('Start card from dropdown, set visibility none!');
        // hidePanel时会立即把窗口设置成透明，因此需要提前设置面板内容组件为不可见，避免模糊缓存失效重绘
        DropdownVm.instance.setVisibility(Visibility.None);
      }, 360);
    }

    // 收起面板的时间需要比下面的卡片动画时间短一点，避免动画最后面板闪现的问题
    setTimeout(() => {
      this.hidePanel();
    }, 380);

    // 执行动画
    await this.startCardAnimation.executeAnimation([
      {
        curve: StartAppOneMirrorAnimation.instance.curve,
        duration: 400,
        event: () => {
          cardVm.contentSize = {
            width: ArkUIAdapter.px2vp(DeviceInfoVm.instance.width),
            height: ArkUIAdapter.px2vp(DeviceInfoVm.instance.height)
          };
          cardVm.translateY = ArkUIAdapter.px2vp(DeviceInfoVm.instance.height / 2) - cardRect.y;
          cardVm.zIndex = 2;
          cardVm.opacity = 0;
        }
      },
      {
        delay: 400,
        duration: 1,
        event: () => {
          // 动效完成后还原参数
          cardVm.contentSize = { width: '100%', height: 'auto' };
          cardVm.translateY = 0;
          cardVm.opacity = 1;
          cardVm.align = Alignment.End;
          cardVm.containerSize = undefined;
        }
      }
    ], cardVm.ntf.hashCode);

    log.showInfo(`Execute start app animation for ${cardVm.ntf.hashCode} complete`);
  }

  /**
   * 拉起wantAgent前置操作
   */
  beforeStartWantAgent(params: NotificationStartWantAgentParams): boolean {
    performanceMonitor.begin('LAUNCHER_APP_LAUNCH_FROM_NOTIFICATIONBAR',
      performanceMonitor.ActionType.LAST_UP, params.cardVm.ntf.creatorBundleName);
    this.reportStartWantAgent(params.cardVm.ntf);
    if (!params.wantAgent) {
      log.showError(`Invalid wantAgent for ${params.cardVm.ntf.hashCode}`);
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.NO_WANTAGENT);
      return false;
    }
    return true;
  }

  /**
   * 拉起wantAgent后置操作
   */
  afterStartWantAgent(params: NotificationStartWantAgentParams, isHidePanel = true): void {
    log.showInfo(`After start want agent for ${params.wantAgentInfo?.bundleName} isHidePanel ${isHidePanel}`);
    performanceMonitor.end('LAUNCHER_APP_LAUNCH_FROM_NOTIFICATIONBAR');
    if (isHidePanel) {
      // 拉起wantAgent后，保底逻辑收起通知面板
      this.hidePanel(true);
      log.showInfo('HandleNtfPanelCollapseByWant. %{public}d %{public}s', params.cardVm.ntf.wantAgentInfo?.operationType, this.vmInjector.scene);
    }
    if (params.cardVm.ntf.isAutoDelete) {
      if (params.cardVm.isPrivacy && params.groupNtf?.isNormalGroup()) {
        NotificationApiUtil.batchRemoveNtfByClick(params.groupNtf.children);
      } else {
        NotificationApiUtil.removeNtfByClick(params.cardVm.ntf);
      }
    }
  }

  /**
   * 通知拉起应用
   * @returns true表示当前不打开应用
   */
  isExcludeForStartApp(params: NotificationStartWantAgentParams): boolean {
    const exclusive = ExclusiveChecker.check(params.wantAgentInfo?.bundleName ?? '', 'FULL_SCREEN', true);
    return exclusive.result;
  }

  /**
   * 拉起wantAgent后上报
   */
  reportStartWantAgent(ntf: NotificationBase) {
    const isInGroup = this.vmInjector.getListVm()?.getGroupNtf(ntf);
    HiDfxEventUtil.reportNotifyItemClick(ntf.creatorBundleName, HiSysDataNotifyClickState.UNLOCK_SINGLE_CLICK);
    const displayScene = this.vmInjector.viewName === ViewName.BANNER_VIEW ? 3 : 4;
    let isMidScene = false;
    if (this.vmInjector.viewName === ViewName.BANNER_VIEW) {
      isMidScene = this.vmInjector.getBannerVm().isMidScene;
    }
    NotificationSysEventReporter.notificationClickApp({
      DISPLAY_SCENE: displayScene,
      CREATOR_BUNDLE_NAME: ntf.creatorBundleName,
      IS_LIVE: ntf.isLiveView() ? 0 : 1,
      NOTIFICATION_ID: ntf.id,
      NOTIFICATION_SLOT_TYPE: ntf.slotType,
      TIME_STAMP: String(DropdownVm.instance.lastDropdownTime),
      IS_IN_GROUP: isInGroup ? 1 : 0,
      IS_MIDSCENE: isMidScene ? 1 : 0,
      USER_ID: ntf.creatorUserId,
      HASHCODE: ntf.hashCode,
      TRACE_ID: ntf.traceId,
      NOTIFICATION_CONTROL_FLAGS: ntf.controlConfig?.flags,
      BUNDLE_TYPE: ntf.bundleType,
    });
  }

  /**
   * 收起面板
   */
  hidePanel(isAnim: boolean = false): void {
    log.showInfo('Hide panel');
    DropdownVm.instance.hidePanel(isAnim);
  }

  /**
   * 由通知卡片拉起应用, 设置拉起原因
   * @param params
   */
  private setLaunchReasonFromNC(params: NotificationStartWantAgentParams): void {
    // 设置extraInfos后,会导致extraInfo失效,因此要先判断extraInfo
    if (params.triggerInfo.extraInfo) {
      params.triggerInfo.extraInfo['ohos.params.launchReasonMessage'] = SystemuiConstants.NC_LAUNCH_REASON_MESSAGE;
    } else if (params.triggerInfo.extraInfos) {
      params.triggerInfo.extraInfos['ohos.params.launchReasonMessage'] = SystemuiConstants.NC_LAUNCH_REASON_MESSAGE;
    } else {
      params.triggerInfo.extraInfos = {
        'ohos.params.launchReasonMessage': SystemuiConstants.NC_LAUNCH_REASON_MESSAGE,
      };
    }
  }
}