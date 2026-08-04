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

import { ILiveHeadsUpVm } from '../interface/ILiveHeadsUpVm';
import { LiveBaseVm } from './LiveBaseVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveHiSysEvent } from '../sysEvent/LiveHiSysEvent';
import { LiveNotification } from '../model/LiveNotification';
import { InnerEventUtil } from '../../utils/InnerEventUtil';
import { NotificationEvent } from '../../event/NotificationEvent';
import { TaskItem, TaskQueue } from '../../utils/TaskQueue';
import { NotificationDataManager } from '../../manager/NotificationDataManager';
import { TimeoutPromise } from '../../base/common/TimeoutProimse';
import { bannerMgr } from '../../banner/phone/BannerManager';
import { ILiveHeadsUpCardVm } from '../interface/ILiveHeadsUpCardVm';
import { LiveHeadsUpSwipeAnimation } from '../animation/LiveHeadsUpSwipeAnimation';
import { BannerPanelType } from '../../banner/common/info/BannerState';
import { DefaultPanelZIndex } from '../../base/common/info/DefaultPanelZIndex';
import { EnvVm } from '../../vm/EnvVm';
import {
  CustomPromise,
  DropDownPanelManagerWrapper,
  obtainLocalEvent,
  sEventManager,
  TargetPanel,
  ViewManagerPolicy,
  viewMgrPolicy,
  ViewType
} from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { DropdownVm } from '../../vm/DropdownVm';
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';
import { StatusBarEventType } from '../../event/StatusBarEvent';
import { NotificationUtil } from '../../utils/NotificationUtil';
import { StartAppOneMirrorAnimation } from '../../animation/StartAppOneMirrorAnimation';
import { LiveStyle } from '../constants/LiveStyle';
import { AnimationBase } from '../../animation/AnimationBase';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import { ClickRegion, DeleteNotificationType } from '../../maintenance/StatisticsConstants';
import {
  ClickMaintenanceInfo,
  ClickNotificationErrorCode,
  ClickNotificationMaintenance
} from '../../maintenance/ClickNotificationMaintenance';
import { ScreenLockAdapter } from '../../adapter/ScreenLockAdapter';
import { NotificationWantAgentInfo } from '../../model/NotificationAppInfo';
import { LogWithHa } from '../../maintenance/CommonExceptionMaintenance';
import { WantAgent, wantAgent } from '@kit.AbilityKit';
import { ILiveMetaBallVisibleVm } from '../interface/ILiveMetaBallVisibleVm';
import { LiveExceptionCode } from '../constants/LiveExceptionCode';
import { DeleteNotificationMaintenance } from '../../maintenance/DeleteNotificationMaintenance';
import { BannerVm } from '../../vm/BannerVm';
import { AppForegroundEvent, AppLifeCycleManager } from '../../manager/AppLifeCycleManager';
import { AbilityState } from '../../plugin/PhoneAppManager';
import { CapsuleTransferParam } from '../interface/ILiveCapsuleListVm';
import { display, LengthMetrics } from '@kit.ArkUI';
import { ResourceVm } from '../../vm/ResourceVm';
import { LiveHeadsUpShowEvent } from '../../notification/model/BannerShowStatusModel';
import { EventBroadcast, SysUiWindowType } from '../../event/EventBroadcast';
import { LiveMetaBallScene } from '../model/LiveCommonModel';
import { scbStatusBarStatusManager } from '../../statusbar/ScbStatusBarStatusManager';
import { sharedData } from '../../model/SendableData';
import { WantAgentUtil } from '../../utils/WantAgentUtil';
import { WindowAdapter } from '../../adapter/WindowAdapter';
import { PowerStatusMonitorAdapter, PowerStatusEnum } from '../../adapter/PowerStatusMonitorAdapter';
import { SceneSessionAdapter } from '../../adapter/SceneSessionAdapter';
import { ArkUIAdapter, ViewName } from '../../utils/ArkUIAdapter';
import { LiveCardFloatingWantAgentParams } from '../interface/ILiveCardFloatingVm';
import { LiveApsUtils } from '../../utils/LiveApsUtils';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/constants/StyleConstants';
import { PriorityWeatherScene } from '../model/LiveWeatherModel';
import { DropDownAdapter } from '../../adapter/DropDownAdapter';
import { CapsuleShowType } from '../model/LiveCommonModel';
import { SCBSceneMode } from '@ohos/windowscene';
import { OutdoorVm } from '../../vm/OutdoorVm';

const TAG = 'LiveHeadsUpVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const HEADS_UP_TIMEOUT = 1000;
const QUEUE_TIMEOUT = 30000;
const NORMAL_BANNER_DURATION = 5000;

/**
 * 实况横幅VM
 */
@ObservedV2
export class LiveHeadsUpVm extends LiveBaseVm implements ILiveHeadsUpVm {
  @Trace public live?: LiveNotification;
  @Trace public showLive?: LiveNotification;
  @Trace public contentOpacity: number = 0;
  public dropdownVm = DropdownVm.instance;
  public contentId: string = this.vmInjector.getId(TAG);
  @Trace public containerSize?: SizeOptions;
  @Trace public contentSize?: SizeOptions = { width: '100%', height: 'auto' };
  @Trace public containerOpacity: number = 1;
  private taskQueue = new TaskQueue(TAG, 1);
  public timeoutMap: Map<string, number> = new Map();
  public isTimeout: boolean = false;
  public startAppFlag: boolean = false;
  private appearPromise?: TimeoutPromise<void>;
  private disappearPromise?: TimeoutPromise<void>;
  private preemptShowPromise?: TimeoutPromise<void>;
  private wantAgentInfo: WantAgent | undefined = undefined;
  public envVm = EnvVm.instance;
  public bannerVm = BannerVm.instance;
  public cutoutVm = CutoutVm.instance;
  public  isHiding: boolean = false; // 当前胶囊是否处于hide中
  public preemption: boolean = false;
  public headsUpNtfHashCode?: string = undefined;
  private isCollapsing: boolean = false;
  private touchStartX: number = 0;
  private touchStartY: number = 0;
  private isPortraitCreated: boolean | undefined = undefined;
  @Trace public contentOffsetX: number = 0;
  @Trace public contentOffsetY: number = 0;
  @Trace public isInterrupt: boolean = false;
  private isOpenFloating = false;
  public isBannerWeatherScene = false;
  private isMidScene: boolean = false;
  public headsUpArea?: Area;

  public onCutoutChange(): void {
    log.showInfo(`contentSize ${this.contentSize?.width}`);
    if (this.live && !this.cutoutVm.isMiddleCutout() && !this.isHiding) {
      log.showInfo(`live ${this.live?.hashCode} is not hidding ${this.isHiding}, need show status bar`);
      this.showStatusBar();
    }
    if (this.live && this.live.isWallet()) {
      this.getCardVm(this.live).setCardResponseRegion(true);
    }
  }

  @Computed get interrupt(): void {
    if (!this.live) {
      return;
    }
    if (!this.isInterrupt) {
      return;
    }
    this.hide(this.live);
  }

  get isTouching(): boolean {
    if (this.live) {
      return this.vmInjector.getLiveHeadsUpSwipeVm(this.live).isTouching;
    }
    return false;
  }

  @Computed
  get metaBallVm() {
    return this.vmInjector.getMetaBallVm();
  }

  @Computed
  get liveMetaBallVisibleVm(): ILiveMetaBallVisibleVm {
    return this.vmInjector.getMetaBallVisibleVm();
  }

  @Computed
  get isLiveHeadsUp(): boolean {
    return this.bannerVm.bannerType === BannerPanelType.TYPE_LIVE_HEADS_UP;
  }

  @Monitor('dropdownVm.isDropDown')
  onDropdownShowChange(): void {
    if (!this.live) {
      return;
    }
    // 只有下拉面板的时候才收起
    if (this.dropdownVm.isDropDown) {
      log.showInfo(`drop down is show need hide banner`);
      this.hideImmediately(this.live);
    }
  }

  @Monitor('envVm.isScreenLock')
  updateHeadUpHashCode(): void {
    log.showInfo(`updateHeadUpHashCode to undefined by screenLock`);
    this.headsUpNtfHashCode = undefined;
    if (this.envVm.isScreenLock && !this.live?.isInstantBanner()) {
      scbStatusBarStatusManager.setNeedStatusBarKeepShowing(false);
      this.live = undefined;
    }
  }

  @Monitor('bannerVm.bannerType')
  onHeadUpBannerTypeChange(): void {
    log.showInfo(`bannerType change to: ${this.bannerVm.bannerType}`);
    if (this.live && this.live.card.isOtherCard()) {
      if (this.bannerVm.bannerType === BannerPanelType.TYPE_LIVE_HEADS_UP) {
        this.isBannerWeatherScene = true;
      }
    }
    this.metaBallVm.setScene(LiveMetaBallScene.HEADS_UP,
      this.bannerVm.bannerType === BannerPanelType.TYPE_LIVE_HEADS_UP);
  }

  public init(): void {
    InnerEventUtil.on(NotificationEvent, this.onNotificationEvent);
    InnerEventUtil.on(LiveHeadsUpShowEvent, this.onLiveHeadsUpShowEvent);
    AppLifeCycleManager.instance.emitter.on('appForegroundStateChanged', this.onAppForegroundStateChange);
    this.registerScreenChangeTransitionController();
  }

  //普通横幅与实况横幅抢占场景，当前通过监听事件实现具体逻辑，后续统一整改
  private onLiveHeadsUpShowEvent = async (event: LiveHeadsUpShowEvent): Promise<void> => {
    if (!this.live) {
      return;
    }
    if (!bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_HEADS_UP)) {
      return;
    }
    if (event.headUpStatus !== LiveHeadsUpShowEvent.EVENT_HIDE_BANNER) {
      return;
    }
    if (this.live.isHeadsUpStick || this.live.isInstantBanner()) {
      bannerMgr.isExclusiveLiveBanner = true;
      return;
    }
    bannerMgr.isExclusiveLiveBanner = false;
    bannerMgr.preemptPromise = new CustomPromise();
    log.showInfo(`normal banner comming, need hide live banner ${this.live?.hashCode}`);
    await this.waitForPreemptShow();
    await this.hide(this.live);
  }

  private onAppForegroundStateChange = async (event: AppForegroundEvent): Promise<void> => {
    if (!this.live) {
      return;
    }
    if (this.isOpenFloating) {
      log.showInfo(`Current app ${event.bundleName}_${event.uid} is open floating`);
      return;
    }
    const bundleName = event?.bundleName;
    const liveBundleName = this.live.creatorBundleName;
    // 存在横幅且横幅应用切换至前台
    let appForeground: boolean = bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_HEADS_UP) &&
      event?.switchAbilityState === AbilityState.ABILITY_STATE_FOREGROUND &&
      (event?.bundleName === this.live.creatorBundleName) &&
      !sharedData.isExecuting;

    log.showInfo(`onForegroundAppEvent bundleName: ${bundleName}, banner BundleName: ${liveBundleName}, appForeground: ${appForeground}`);
    if (appForeground) {
      this.hide(this.live);
    }
  }

  private registerScreenChangeTransitionController(): void {
    PowerStatusMonitorAdapter.subscribe({ stage: PowerStatusEnum.BEGIN_DISPLAY_ON, callback: () => this.disPlayOn() },
      `${TAG}_BEGIN_DISPLAY_ON`);
    PowerStatusMonitorAdapter.subscribe({ stage: PowerStatusEnum.BEGIN_DISPLAY_OFF, callback: () => this.displayOff() },
      `${TAG}_BEGIN_DISPLAY_OFF`);
  }

  private disPlayOn(): void {
    log.showInfo(`disPlayOn, live ${this.live?.hashCode}`);
    if (this.live) {
      if (this.envVm.isScreenLock && this.live?.isInstantBanner()) {
        this.setBannerZIndex(DefaultPanelZIndex.PANEL_STATUS_BAR_LOWER - 1);
      }
    }
  }

  private displayOff(): void {
    log.showInfo(`disPlayOff, live ${this.live?.hashCode}`);
    if (this.live) {
      if (this.envVm.isScreenLock && this.live?.isInstantBanner()) {
        this.setBannerZIndex(DefaultPanelZIndex.PANEL_BANNER);
      }
      if (this.envVm.isScreenLock && !this.live?.isInstantBanner()) {
        this.headsUpNtfHashCode = undefined;
      }
    }
  }

  public preemptShowFinish = (): void => {
    log.showInfo(`show finish, ${this.live?.hashCode}`);
    this.preemptShowPromise?.resolve();
    this.preemptShowPromise = undefined;
  };

  public onContentAppear = (): void => {
    log.showInfo(`onContentAppear, ${this.live?.hashCode}`);
    this.appearPromise?.resolve();
    this.appearPromise = undefined;
  };
  public onContentDisappear = (): void => {
    log.showInfo(`onContentDisappear, ${this.live?.hashCode}`);
    this.disappearPromise?.resolve();
    this.disappearPromise = undefined;
  };
  public onClick = async (): Promise<void> => {
    this.headsUpNtfHashCode = undefined;
    await this.refreshMidSceneState();
    // 全场景通知
    if (this.live?.isCollaNotification) {
      this.handleClickForCollaNotification();
      return;
    }

    if (!this.live?.wantAgent) {
      log.showError(`Invalid wantAgent for ${this.live?.hashCode}`);
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.INVALID_WANTAGENT, {
        data: this.live,
        clickRegion: ClickRegion.BANNER_MAIN,
      });
      return;
    }
    if (this.isHiding) {
      log.showInfo(`live ${this.live?.hashCode} is hidding, no need response click event`);
      return;
    }
    log.showInfo(`Start wantAgent for ${this.live?.hashCode}, isScreenLock: ${this.envVm.isScreenLock}`);
    // 锁屏场景处理
    if (this.envVm.isScreenLock) {
      //钱包不受锁屏限制，可以直接跳过解锁拉起应用
      this.handleClickForScreenLock();
      return;
    }
    // 从横幅拉起应用
    this.startWantAgentByHeadsUp();
  }

  // 处理支持全场景的横幅点击
  private async handleClickForCollaNotification(): Promise<void> {
    if (!this.live) {
      return;
    }
    const clickInfo = ClickNotificationMaintenance.getInfo();
    try {
      log.showInfo(`start banner CollaNotification WantAgent for ${this.live.hashCode}`);
      await NotificationUtil.distributeOperation(this.live.hashCode, LiveStyle.DISTRIBUTE_OPERATION_CARD_JUMP);
      ClickNotificationMaintenance.reportClick(undefined, clickInfo);
      log.showInfo(`CollaNotification: ${this.live.hashCode} start WantAgent success.`);
      bannerMgr.releaseLiveHeadsUp();
      return;
    } catch (e) {
      log.showError(`start CollaNotification WantAgent for ${this.live.hashCode} failed:`, e);
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.TRIGGER_WANTAGENT_FAIL, clickInfo, e);
      return;
    }
  }

  private async refreshMidSceneState(): Promise<void> {
    this.isMidScene = await SceneSessionAdapter.getIsMidScene(sharedData.bannerScreenId);
    log.showInfo(TAG, `update isMidScene: ${this.isMidScene}`);
  }

  // 处理锁屏横幅点击场景
  private async handleClickForScreenLock(): Promise<void> {
    this.wantAgentInfo = this.live?.wantAgent;
    const agentInfo = this.live?.wantAgentInfo ?? await WantAgentUtil.parseWantAgentInfo(this.wantAgentInfo);
    if (!agentInfo) {
      return;
    }
    // 恢复面板层级
    this.handleBannerZIndex();
    bannerMgr.releaseLiveHeadsUp();

    if (this.live?.isWallet()) {
      await this.startWantAgent(agentInfo);
      LiveHiSysEvent.reportLiveClickAppEvent(this.live, 3, this.isMidScene);
      return;
    }

    try {
      ScreenLockAdapter.requestUnlock({
        success: async (): Promise<void> => {
          this.startAppFlag = await this.startWantAgent(agentInfo);
          log.showInfo(`Start wantAgent success for ${this.live?.hashCode} in lock status`);
        },
        withDelay: true,
      }, TAG);
    } catch (e) {
      LogWithHa.info(log, `Start wantAgent fail for ${e}`, LiveExceptionCode.UNLOCK_FAIL, e);
    }
    return;
  }

  public async startWantAgentByHeadsUp(): Promise<void> {
    if (!this.live) {
      log.showWarn(`live is invalid, start wantAgent fail`);
      return;
    }
    if (await this.tryOpenFloating(this.live)) {
      log.showInfo(`tryOpenFloating success`);
      return;
    }
    this.wantAgentInfo = this.live?.wantAgent;
    const agentInfo = this.live?.wantAgentInfo ?? await WantAgentUtil.parseWantAgentInfo(this.wantAgentInfo);
    if (await this.tryOpenFloating(this.live)) {
      return;
    }
    //非锁屏拉起应用前台
    await this.startWantAgent(agentInfo);
    if (!this.startAppFlag) {
      return;
    }
    this.hideImmediately(this.live);
  }

  private setMidSceneParam(agentInfo: NotificationWantAgentInfo, triggerInfo: wantAgent.TriggerInfo) {
    log.showInfo(`setMidSceneParam. isMidScene: ${this.isMidScene}`)
    if (this.isMidScene && agentInfo?.want?.parameters) {
      agentInfo.want.parameters['midSceneNotification'] = this.isMidScene;
      // 中景窗windowModel也使用FLOATING
      triggerInfo.startOptions = { windowMode: SCBSceneMode.FLOATING }
    }
  }

  protected async tryOpenFloating(live: LiveNotification): Promise<boolean> {
    const floatingVm = this.vmInjector.getCardFloatingVm(live);
    const swipeVm = this.vmInjector.getLiveHeadsUpSwipeVm(live);
    const params: LiveCardFloatingWantAgentParams = { wantAgent: live.wantAgent, wantAgentInfo: live.wantAgentInfo };
    if (!live.isWallet() && await floatingVm.canOpenFloating(params)) {
      swipeVm.isTouching = true;
      this.isOpenFloating = true;
      floatingVm.startFloatingForClick(params);
      floatingVm.runCardHideAnimation(() => {
        this.contentOpacity = 0;
      }).then(() => {
        this.isOpenFloating = false;
        swipeVm.isTouching = false;
        this.hideImmediately(live);
      });
      return true;
    }
    return false;
  }

  private async startWantAgent(agentInfo: NotificationWantAgentInfo | undefined): Promise<boolean> {
    const clickInfo: ClickMaintenanceInfo = {
      data: this.live,
      clickRegion: ClickRegion.BANNER_MAIN,
    };
    let triggerInfo: wantAgent.TriggerInfo = { code: 0 };
    try {
      log.showInfo(`AgentInfo bundle: ${agentInfo?.bundleName}, operationType: ${agentInfo?.operationType}`);
      if (agentInfo && WantAgentUtil.isStartApp(agentInfo)) {
        this.startAppFlag = true;
        this.vmInjector.getCapsuleListVm().isToEnterAppByClickCard = true;
        this.vmInjector.getCapsuleListVm().enterApplicationName = agentInfo.bundleName;
        const cardRect =
          SystemUICommonUtil.getRect(this.contentId, ArkUIAdapter.getUiContextByViewName(ViewName.BANNER_VIEW));
        this.setMidSceneParam(agentInfo, triggerInfo);
        const promise = StartAppOneMirrorAnimation.instance.prepare({
          scene: this.vmInjector.scene,
          cardRect: cardRect,
          cardRadius: LiveStyle.CAPSULE_RADIUS,
          bundleName: agentInfo.bundleName,
          onExecute: () => this.onStart(cardRect),
        })
        const result = await Promise.all([promise, WantAgentUtil.startWantAgent(this.wantAgentInfo, triggerInfo)]);
        ClickNotificationMaintenance.reportClickWithResult(result[1], ClickNotificationErrorCode.TRIGGER_WANTAGENT_FAIL,
          clickInfo);
        return true;
      } else {
        this.startAppFlag = false;
        const isSuccess = await WantAgentUtil.startWantAgent(this.wantAgentInfo);
        ClickNotificationMaintenance.reportClickWithResult(isSuccess, ClickNotificationErrorCode.TRIGGER_WANTAGENT_FAIL,
          clickInfo);
        return false;
      }
    } catch (e) {
      log.error(`Start card wantAgent for ${this.live?.hashCode} error:`, e);
      ClickNotificationMaintenance.reportClickWithResult(false, ClickNotificationErrorCode.TRIGGER_WANTAGENT_FAIL,
        clickInfo);
    } finally {
      this.vmInjector.getCapsuleListVm().isToEnterAppByClickCard = false;
      this.vmInjector.getCapsuleListVm().enterApplicationName = undefined;
    }
    this.startAppFlag = false;
    return false;
  }

  protected async onStart(cardRect: RectResult): Promise<void> {
    log.showInfo(`On execute start app animation for begin`);
    const animation = new AnimationBase(AnimationBase.NAMES.NTF_OVERLAY_ANIMATION);

    // 动效开始前设置参数
    animation.setInitialState(() => {
      this.contentSize = { width: cardRect.width, height: cardRect.height };
    });

    // 执行动画
    LiveApsUtils.setLiveApsScene(StyleConstants.DEFAULT_1);
    await animation.executeAnimation([
      {
        curve: StartAppOneMirrorAnimation.instance.curve,
        duration: 400,
        event: () => {
          this.containerOpacity = 0;
        }
      },
      {
        delay: 400,
        duration: 1,
        event: () => {
          // 动效完成后还原参数
          this.containerSize = undefined;
          this.contentOffsetY = 0;
          this.contentSize = { width: '100%', height: 'auto' };
        }
      }
    ], this.live?.hashCode);
    LiveApsUtils.setLiveApsScene(StyleConstants.DEFAULT_0);
    log.showInfo(`Execute start app animation for ${this.live?.hashCode} complete`);
  }

  private waitForAppear(): Promise<void> {
    this.contentOpacity = 0;
    this.appearPromise = new TimeoutPromise(TAG + '_show');
    this.appearPromise.startTimeout(HEADS_UP_TIMEOUT);
    return this.appearPromise;
  }

  private waitForDisappear(): Promise<void> {
    this.disappearPromise = new TimeoutPromise(TAG + '_hide');
    this.disappearPromise.startTimeout(HEADS_UP_TIMEOUT);
    return this.disappearPromise;
  }

  private waitForPreemptShow(): Promise<void> {
    this.preemptShowPromise = new TimeoutPromise(TAG + 'showPromise');
    this.preemptShowPromise.startTimeout(HEADS_UP_TIMEOUT);
    return this.preemptShowPromise;
  }

  private initStatus(live: LiveNotification): void {
    this.isTimeout = false;
    this.contentOffsetX = 0;
    this.contentOffsetY = 0;
    this.containerOpacity = 1;
    this.startAppFlag = false;

    //锁屏场景需要调整层级，实况横幅需要展示在锁屏及其应用层级之上，当前设置区间为: 锁屏键盘<banner<导航条
    if ((this.envVm.isScreenLock || this.envVm.isScreenOff) && live.isInstantBanner()) {
      this.setBannerZIndex(DefaultPanelZIndex.PANEL_STATUS_BAR_LOWER - 1);
    }
  }

  public async show(live: LiveNotification, isUpdate: boolean = false): Promise<boolean> {
    if (!OutdoorVm.instance.isInOutdoorAppList(live)) {
      log.showWarn(`${live.hashCode} is not in OutdoorAppList`);
      return false;
    }
    const cardVm = this.getCardVm(live);
    if (!cardVm.isNeedShow(live)) {
      log.showInfo(`live no need show`);
      if (live.isInstantBanner()) {
        this.checkRemove(live);
      }
      this.togCapsuleList(undefined);
      return false;
    }
    this.bannerVm.checkDeviceStatus();
    if (live.isPhoneCall() && this.dropdownVm.dropdownEvent.target === TargetPanel.CONTROL_CENTER_PANEL) {
      log.showInfo('show banner because live is phone call');
      this.headsUpNtfHashCode = live.hashCode;
      DropDownAdapter.hideWindowDirectly();
    }
    if (this.live?.isHeadsUpStick && live.hashCode !== this.live?.hashCode) {
      log.showInfo(`stick banner ${this.live?.hashCode} showing, no need show other banner ${live.hashCode}, isUpdate: ${isUpdate}`);
      if (live.isInstantBanner()) {
        this.checkRemove(live);
      }
      //等待消息入capsuleList队列后在进行toggle，否则会产生时序问题，导致新增胶囊不展示
      await SystemUICommonUtil.sleep(5);
      const showType = this.vmInjector.getCapsuleVm(live).showType;
      if (isUpdate &&
        (showType === CapsuleShowType.HANGING_HOLE || showType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED ||
          showType === CapsuleShowType.TOP || showType === CapsuleShowType.SELF_ADAPTIVE_ROUND_CAKE)) {
        this.vmInjector.getCapsuleListVm().animateToLayoutViewForUpdate(live);
      } else {
        this.togCapsuleList(this.live?.hashCode);
      }
      return false;
    }
    if (bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_LIST)) {
      if (!live.isInstantBanner()) {
        return false;
      } else {
        const switchVm = this.vmInjector.getSwitchVm();
        switchVm.collapseCardToCapsule();
        //等待卡片全部收回后
        this.isCollapsing = true;
        await SystemUICommonUtil.sleep(169);
      }
    }

    const oldLive = this.live;

    // 当前面板正在展示横幅，此时横幅更新，只更新横幅内容
    if (oldLive?.hashCode === live.hashCode) {
      await this.showingLiveUpdate(live);
      return true;
    }
    //出场初始化
    this.initStatus(live);

    // 当前未在横幅面板,收到新实况横幅时更新系统实况，需要收起胶囊，然后吐出横幅卡片
    if (!oldLive && this.isOtherLiveUpdate(live)) {
      log.showInfo(`start update capsule to banner ${live.hashCode}`);
      if (!(await WindowAdapter.isViewShowing(ViewType.STATUS_BAR))) {
        this.headsUpNtfHashCode = live.hashCode;
        scbStatusBarStatusManager.setNeedStatusBarKeepShowing(true);
        this.togCapsuleList(live.hashCode, { needAnimation: false });
        await this.showBanner(live);
      } else {
        this.togCapsuleList(live.hashCode);
        await this.showBanner(live);
      }
      return true;
    }

    // 如果之前显示的实况和本次要显示的不是同一个则先隐藏上一个
    if (oldLive && oldLive.hashCode !== live.hashCode) {
      log.showInfo(`Hide old ${oldLive.hashCode} and show new ${live.hashCode}`);
      if (this.isHiding) {
        await this.waitForDisappear();
      } else {
        this.isHiding = true;
        //当前存在横幅1，来即时横幅2，收起横幅1; 否则收起横幅1和做胶囊动效
        if (live.isInstantBanner()) {
          await this.getCardVm(oldLive).hide();
        } else {
          await this.checkAddOrUpdate(oldLive, live);
        }
        this.checkRemove(oldLive);
      }
      this.isHiding = false;
      if (this.live && this.isHiding) {
        // 避免重复wait
        this.live = undefined;
        await this.waitForDisappear();
      }
      //抢占态时，需要等待组件下树
      await SystemUICommonUtil.sleep(10);
      if (!live.isInstantBanner()) {
        await Promise.all([
          this.togCapsuleList(live.hashCode),
          this.showBanner(live, true),
        ]);
        return true;
      }
      if (live.isInstantBanner() && !oldLive.isInstantBanner()) {
        this.togCapsuleList(undefined);
        await this.showBanner(live, true);
        return true;
      }
    }
    if (!(await WindowAdapter.isViewShowing(ViewType.STATUS_BAR)) && !live.isInstantBanner()) {
      this.headsUpNtfHashCode = live.hashCode;
      scbStatusBarStatusManager.setNeedStatusBarKeepShowing(true);
      WindowAdapter.showView(ViewType.STATUS_BAR);
      this.togCapsuleList(live.hashCode, { needAnimation: false });
      await this.showBanner(live);
    } else {
      await this.showBanner(live);
    }
    return true;
  }

  private async checkAddOrUpdate(oldLive: LiveNotification, live: LiveNotification): Promise<void> {
    //等待消息入capsuleList队列后在进行toggle，否则会产生时序问题
    await SystemUICommonUtil.sleep(5);
    await Promise.all([
      this.getCardVm(oldLive).hide(),
      this.togCapsuleList(live.hashCode),
    ]);
  }

  private async showBanner(live: LiveNotification, preemption?: boolean): Promise<void> {
    if (!bannerMgr.requestLiveHeadsUp()) {
      log.showWarn(`Cannot request live heads up: ${bannerMgr.getBannerState().bannerPanelType.bannerPanelType}`);
      return;
    }
    this.preemption = preemption ?? false;
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
    const oldLive = capsuleMarqueeVm.live;
    this.vmInjector.updateVmByLive(live, TAG);
    // 胶囊文字后续更新
    log.showInfo(`update MarqueeVm to old live: ${oldLive.uid}, ${live.uid}`);
    capsuleMarqueeVm.onUpdate(oldLive);
    this.live = live;
    this.showLive = live;
    await this.waitForAppear();
    if (!this.isCollapsing && !this.isImmersiveWallet()) {
      if (!this.vmInjector.getCapsuleListVm().getShowCapsuleListNum()) {
        this.metaBallVm.toggleState();
      }
    }
    this.isCollapsing = false;
    if (!live.isInstantBanner()) {
      await this.showStatusBar();
    }
    this.contentOpacity = 1;
    await this.getCardVm(live).show(live, preemption);
    this.preemptShowFinish();
    this.preemption = false;
    log.showInfo(`show banner end`);
  }

  private isImmersiveWallet(): boolean {
    const isWallet = this.live?.isWallet() ?? false;
    this.isPortraitCreated =
      this.isPortraitCreated ?? DeviceInfoVm.instance.orientation === display.Orientation.PORTRAIT;
    return isWallet && !this.isPortraitCreated;
  }

  private async showStatusBar(): Promise<void> {
    // 当前有胶囊/卡片出场标志，需要呼出状态栏
    let event = new LiveHeadsUpShowEvent();
    event.headUpStatus = LiveHeadsUpShowEvent.EVENT_SHOW_BANNER;
    InnerEventUtil.post(LiveHeadsUpShowEvent, event);
    scbStatusBarStatusManager.setNeedStatusBarKeepShowing(true);
    WindowAdapter.showView(ViewType.STATUS_BAR);
    //等待状态栏出现后在执行动画, 只需要有个等待动作
    await SystemUICommonUtil.sleep(2);
  }

  private async showingLiveUpdate(live: LiveNotification): Promise<void> {
    // 如果当前显示的实况和本次要显示的是同一个则更新它
    log.showInfo(`Update for ${live.hashCode}`);
    await this.getCardVm(live).update(live);
    this.live = live;
    this.showLive = live;
    return;
  }

  private isOtherLiveUpdate(live: LiveNotification): boolean {
    const upDateLive = this.vmInjector.getCapsuleListVm().liveList.find((capsuleLive) => {
      if (capsuleLive.hashCode === live.hashCode) {
        return true;
      } else {
        return false;
      }
    });
    if (upDateLive) {
      return true;
    }
    return false;
  }

  private async togCapsuleList(hashcode?: string, capsuleTransferParam?: CapsuleTransferParam): Promise<void> {
    log.showInfo(`togCapsuleList for ${hashcode}`);
    this.headsUpNtfHashCode = hashcode;
    await this.vmInjector.getCapsuleListVm().toggleCapsuleList(capsuleTransferParam);
  }

  public async hide(live: LiveNotification): Promise<void> {
    if (this.live?.hashCode !== live.hashCode || this.isHiding) {
      log.showWarn(`Hide return, current live is ${this.live?.hashCode}, remove live is ${live.hashCode} ${this.isHiding}`);
      return;
    }
    this.isHiding = true;
    log.showInfo(`Hide for ${this.live.hashCode}`);
    this.broadcastHideBanner(live);
    if (live.isInstantBanner()) {
      if (!this.isImmersiveWallet() && !this.vmInjector.getCapsuleListVm().getShowCapsuleListNum()) {
        this.metaBallVm.toggleState();
      }
      this.isPortraitCreated = undefined;
      await this.getCardVm(live).hide();
    } else {
      this.isPortraitCreated = undefined;
      await this.handlePreemptScene(live);
    }
    // 如果是定时器到了，hide上一个横幅时，又来一个新横幅，则不需要release，否则有时序问题导致横幅不展示
    if (this.live && this.live?.hashCode === live.hashCode) {
      log.showInfo(`Hide for ${this.live.hashCode} for timeout and no other live comming`);
      this.live = undefined;
      this.showLive = undefined;
      this.handleBannerZIndex();
      await this.waitForDisappear();
      if (!bannerMgr.preemptPromise) {
        log.showInfo('hide liveHeadsUp is release panel');
        bannerMgr.releaseLiveHeadsUp();
      }
      //点击胶囊展开，打断横幅时，不用收起状态栏，但是变量需要设置为false
      scbStatusBarStatusManager.setNeedStatusBarKeepShowing(false);
      if (!this.isInterrupt) {
        sEventManager.publish(obtainLocalEvent(StatusBarEventType.STATUS_BAR_HIDE, false));
      }
      //抢占态时，需要等待组件下树,才能正常上树
      await SystemUICommonUtil.sleep(10);
    }
    if (bannerMgr.preemptPromise) {
      log.showInfo('preemptPromise is exist');
      bannerMgr.preemptPromise.resolve();
      bannerMgr.preemptPromise = undefined;
    }
    if (live.isInstantBanner()) {
      this.checkRemove(live);
    }
    this.isTimeout = false;
    // 正常收起后,重置场景
    this.isInterrupt = false;
    this.vmInjector.getCapsuleListVm().isInterruptInstantBanner = false;
    this.isHiding = false;
    this.clearTimeout(live);
  }

  protected handleBannerZIndex(): void {
    this.setBannerZIndex(DefaultPanelZIndex.PANEL_BANNER);
  }

  private async handlePreemptScene(live: LiveNotification): Promise<void> {
    log.showInfo(`preemptPromise ${bannerMgr.preemptPromise}`);
    if (bannerMgr.preemptPromise) {
      await Promise.all([
        this.togCapsuleList(undefined),
        this.getCardVm(live).hide(),
        SystemUICommonUtil.sleep(200).then(() => {
          log.showInfo(`preemptPromise resolved`);
          bannerMgr.preemptPromise?.resolve();
        })
      ])
      return;
    }
    if (!this.isInterrupt) {
      await Promise.all([
        this.togCapsuleList(undefined),
        this.getCardVm(live).hide(),
      ])
    } else {
      this.headsUpNtfHashCode = undefined;
      this.getCardVm(live).hide();
      await SystemUICommonUtil.sleep(200); //等待卡片收起，需要比实况列表展开的时间220ms短
    }
  }

  public async hideImmediately(live: LiveNotification): Promise<void> {
    if (!this.live || (this.live?.hashCode !== live.hashCode)) {
      return;
    }
    this.clearTimeout(live);
    this.broadcastHideBanner(live);
    log.showInfo(`Hide Immediately for ${this.live?.hashCode}`);
    this.headsUpNtfHashCode = undefined
    this.isPortraitCreated = undefined;
    this.live = undefined;
    this.showLive = undefined;
    this.isHiding = false;
    this.handleBannerZIndex();
    await this.waitForDisappear();
    bannerMgr.releaseLiveHeadsUp();
    //点击胶囊展开，打断横幅时，不用收起状态栏，但是变量需要设置为false
    scbStatusBarStatusManager.setNeedStatusBarKeepShowing(false);
    this.isTimeout = false;
    this.isInterrupt = false;
    if (bannerMgr.preemptPromise) {
      bannerMgr.preemptPromise.resolve();
      bannerMgr.preemptPromise = undefined;
    }
    if (live.isInstantBanner()) {
      log.showInfo(`remove InstantBanner immediately.`);
      this.getCardVm(live).hide();
      NotificationDataManager.instance.removeLiveView([live]);
    }
  }

  private broadcastHideBanner(live: LiveNotification): void {
    if (!live.isLiveView()) {
      log.showInfo(`broadcastHideBanner fail, ntf is not liveView`);
      return;
    }
    log.showInfo(`broadcastHideBanner hide headsup ${live.toSimpleString()}`);
    let dataBanner: Map<string, string> = new Map();
    dataBanner.set('id', `${live.id}`);
    dataBanner.set('creatorBundleName', `${live.creatorBundleName}`);

    EventBroadcast.broadcastEvent(SysUiWindowType.WINDOW_BANNER, false, dataBanner);
  }

  private exceptInstantBanner(live: LiveNotification): boolean {
    return !live.isWallet() && !live.isFaceLock();
  }

  private onNotificationEvent = (event: NotificationEvent): void => {
    const live = event.notificationList.find((ntf) => ntf.isLiveView()) as LiveNotification;
    if (!live) {
      return;
    }

    log.showInfo(`Recieve live event: ${event.eventType},live hashCode: ${live.hashCode} exist live: ${this.live?.hashCode}`);
    // 对正在展示的横幅消息进行更新时，如果更新时发送的更新态信息为非横幅消息，则收起该横幅
    if (this.checkHideHeadsUp(live, event) && (this.live?.hashCode === live.hashCode) &&
    this.exceptInstantBanner(live) &&
      !event.isBatch) {
      log.showInfo(`hide exist banner by update`);
      let task = new TaskItem('hideExistBannerByUpdate', () => this.hide(live));
      task.timeout = QUEUE_TIMEOUT;
      this.taskQueue.add(task);
    }
    // 非横幅或者非即时横幅则不处理
    if (this.checkNoNeedHandle(live, event)) {
      log.showInfo(`not banner or instant banner`);
      return;
    }

    if (!live.isWallet() && event.eventType === NotificationEvent.EVENT_TYPE_UPDATE &&
      this.live?.hashCode === live.hashCode) {
      log.showInfo(`live update now, need refresh date`);
      this.getCardVm(live).update(live);
      this.live = live;
      this.showLive = live;
      if (live.isFaceLock()) {
        return;
      }
    }

    // 即时横幅不受锁屏和解锁限制，都需要展示
    bannerMgr.isInstantBanner = live.isInstantBanner() ? true : false;
    let task: TaskItem | undefined = undefined;
    if (event.eventType === NotificationEvent.EVENT_TYPE_ADD) {
      task = new TaskItem('onAdd', () => this.onAdd(live));
    } else if (event.eventType === NotificationEvent.EVENT_TYPE_UPDATE) {
      task = new TaskItem('onUpdate', () => this.onUpdate(live));
    } else if (event.eventType === NotificationEvent.EVENT_TYPE_REMOVE) {
      task = new TaskItem('onRemove', () => this.onRemove(live));
    }
    if (task) {
      task.timeout = QUEUE_TIMEOUT;
      this.taskQueue.add(task);
    }
  };

  private checkHideHeadsUp(live: LiveNotification, event: NotificationEvent): boolean {
    const voip = live.sysVOIPStatus ?? -1;
    log.showInfo(`checkHideHeadsUp, live status: ${live.isHeadsUpStick} ${live.isHeadsUp} ${voip}`);
    if (voip >= 0) {
      if (!live.isHeadsUp && !live.isHeadsUpStick) {
        return true;
      }
      return false;
    }
    return !live.isHeadsUp;
  }

  /**
   * voip约定只有要展示横幅时,有如下约束:
   * 1、创建:
   * 需要弹横幅：isHeadsUp=true、isHeadsUpStick=true
   * 不需要弹横幅：isHeadsUp=false、isHeadsUpStick=true
   * 2、更新, isHeadsUp=false、isHeadsUpStick=true
   * 3、删除, isHeadsUp=false、isHeadsUpStick=true
   * @param live
   * @param event
   * @returns
   */

  private checkNoNeedHandle(live: LiveNotification, event: NotificationEvent): boolean {
    const coverScene = live.isInstantBanner() || event.eventType === NotificationEvent.EVENT_TYPE_REMOVE;
    if (coverScene) {
      return false;
    }
    const voip = live.sysVOIPStatus ?? -1;
    log.showInfo(`checkNoNeedHandle, live status: ${live.isHeadsUpStick} ${live.isHeadsUp} ${voip} ${event.eventType}`);

    if (voip >= 0) {
      if (event.eventType === NotificationEvent.EVENT_TYPE_ADD) {
        return !live.isHeadsUp;
      }
      if (event.eventType === NotificationEvent.EVENT_TYPE_UPDATE) {
        if (this.live?.hashCode === live.hashCode) {
          return !live.isHeadsUpStick;
        } else {
          return true;
        }
      }
    }
    return !live.isHeadsUp;
  }

  private async onAdd(live: LiveNotification): Promise<void> {
    log.showInfo(`start onAdd for ${live.hashCode}`);
    const isShow = await this.show(live);
    this.setTimeout(live, isShow);
    log.showInfo(`onAdd finish for ${live.hashCode}`);
  }

  private async onUpdate(live: LiveNotification): Promise<void> {
    log.showInfo(`start onUpdate for ${live.hashCode}`);
    const isShow = await this.show(live, true);
    this.setTimeout(live, isShow);
    log.showInfo(`onUpdate finish for ${live.hashCode}`);
  }

  private async onRemove(live: LiveNotification): Promise<void> {
    log.showInfo(`start onRemove for ${live.hashCode}`);
    this.clearTimeout(live);
    await this.hide(live);
    this.clearInstantBannerVm(live);
    log.showInfo(`onRemove finish for ${live.hashCode}`);
  }

  /**
   * 设置实况数据超时计时器
   * @param live
   */
  private setTimeout(live: LiveNotification, isShow: boolean): void {
    if (live.isHeadsUpStick || !isShow || !this.live) {
      return;
    }
    this.clearTimeout(live);
    log.showInfo(`start set timeout for ${live.hashCode}`);
    const timeoutId = setTimeout(() => {
      log.showInfo(`Live ${live.hashCode} is timeout`);
      let task = new TaskItem('checkIsNeedRemove', () => this.checkIsNeedRemove(live));
      task.timeout = QUEUE_TIMEOUT;
      this.taskQueue.add(task);
    }, live.isInstantBanner() ? live.duration : NORMAL_BANNER_DURATION);
    this.timeoutMap.set(live.hashCode, timeoutId);
  }

  private async checkIsNeedRemove(live: LiveNotification): Promise<void> {
    this.isTimeout = true;
    if (this.isTouching) {
      log.showInfo(`finger is touch in card`);
      return;
    }
    const timeoutId = this.timeoutMap.get(live.hashCode);
    if (timeoutId === undefined) {
      return;
    }
    clearTimeout(timeoutId);
    this.timeoutMap.delete(live.hashCode);
    await this.checkRemove(live);
  }

  private async checkRemove(live: LiveNotification): Promise<void> {
    this.clearTimeout(live);
    if (!live.isInstantBanner()) {
      await this.hide(live);
      return;
    }
    DeleteNotificationMaintenance.addNtfMap([live], this.isTimeout ?
      DeleteNotificationType.INSTANT_BANNER_TIMEOUT_DELETE : DeleteNotificationType.DROP_DOWN_INSTANT_DELETE, false);
    NotificationDataManager.instance.removeLiveView([live]);
  }

  private clearInstantBannerVm(live: LiveNotification) {
    if (!live.isInstantBanner()) {
      return;
    }
    this.vmInjector.deleteVmByLive(live);
  }

  /**
   * 清理实况数据超时计时器
   * @param live
   */
  public clearTimeout(live: LiveNotification): void {
    const timeoutId = this.timeoutMap.get(live.hashCode);
    if (timeoutId !== undefined) {
      log.showInfo(`start clear timeout for ${live.hashCode}`);
      clearTimeout(timeoutId);
      this.timeoutMap.delete(live.hashCode);
    }
  }

  public getCardVm(live: LiveNotification): ILiveHeadsUpCardVm {
    if (live.isWallet()) {
      return this.vmInjector.getLiveHeadsUpWalletCardVm();
    }
    if (live.isFaceLock()) {
      return this.vmInjector.getLiveHeadsUpFaceLockVm();
    }
    return this.vmInjector.getLiveHeadsUpCommonCardVm();
  }

  public onTouchEvent = (event: TouchEvent): void => {
    const animation = new LiveHeadsUpSwipeAnimation(this.vmInjector.getLiveHeadsUpCommonCardVm())
    if (this.live) {
      if (event.type === TouchType.Down) {
        animation.touch(true);
        this.touchStartX = event.changedTouches[0].windowX;
        this.touchStartY = event.changedTouches[0].windowY;
      } else if (event.type === TouchType.Up ||
        event.type === TouchType.Move &&
          (Math.abs(this.touchStartX - event.changedTouches[0].windowX) > 4 ||
            Math.abs(this.touchStartY - event.changedTouches[0].windowY) > 4)) {
        animation.touch(false);
      }
    }
  }
  public onListAreaChange = (oldArea: Area, area: Area): void => {
    if (!this.live) {
      log.showInfo(`On list area change,live`);
      return;
    }
    if (this.live.isWallet()) {
      log.showInfo(`On list area change, this.live.isWallet()`);
      return;
    }
    if (this.live.isFaceLock()) {
      return;
    }
    if (!bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_HEADS_UP)) {
      log.showInfo(`On list area change, TYPE_LIVE_HEADS_UP`);
      return;
    }
    log.showInfo(`On list area change, area height = ${area.height}, area width = ${area.width}`);
    this.headsUpArea = area;
    bannerMgr.setResponseRegion(area, BannerPanelType.TYPE_LIVE_HEADS_UP);
  };

  public setBannerZIndex(zIndex?: number): void {
    if (!zIndex) {
      return;
    }
    let curIndex = WindowAdapter.getZIndex(ViewType.NOTIFICATION_BANNER);
    log.showInfo(`upBannerZIndex: curIndex: ${curIndex}  zIndex:${zIndex}`);
    if (zIndex !== curIndex) {
      // 临时提升面板层级
      WindowAdapter.setZIndex(ViewType.NOTIFICATION_BANNER, zIndex);
    }
  }

  public getContainerWidth(containerWidth: number): number {
    log.showInfo(`start get container width for ${this.live?.hashCode}, origin width ${containerWidth}`);
    if (this.live?.isWallet()) {
      return containerWidth - 0.1;
    }
    return containerWidth;
  }

  public getCardMargin(): LengthMetrics {
    return (BannerVm.instance.isCardCenterLayout() || this.showLive?.isFaceLock()) ? LengthMetrics.vp(0) :
    LengthMetrics.vp(this.vmInjector.getCapsuleListVm().position.statusBarClockLeftSpace);
  }

  public getCardAlign(): Alignment {
    return (BannerVm.instance.isCardCenterLayout() || this.showLive?.isFaceLock()) ? Alignment.Top :
      (ResourceVm.instance.isRTL ? Alignment.TopEnd : Alignment.TopStart);
  }

  public getCardPadding(): number {
    return this.live?.isInstantBanner() ? BannerVm.instance.instantBannerContainerMarginTop :
      BannerVm.instance.containerMarginTop;
  }
}