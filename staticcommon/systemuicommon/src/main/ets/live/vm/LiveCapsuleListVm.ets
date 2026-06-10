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

import {
  CapsulePositionChangeCallback,
  CapsuleTransferParam,
  ILiveCapsuleListVm,
  StatusBarChangeCallback
} from '../interface/ILiveCapsuleListVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CustomPromise, obtainLocalEvent, sEventManager, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { LiveNotification } from '../model/LiveNotification';
import { LiveBaseVm } from './LiveBaseVm';
import { NotificationArray } from '../../model/NotificationBase';
import { StatusBarCapsulePosition } from '../../statusbar/model/StatusBarCapsulePosition';
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import {
  CapsuleShowType,
  LiveMetaBallScene,
  LiveCapsuleLayoutInfo,
  LiveCapsuleLayoutScene
} from '../model/LiveCommonModel';
import { LiveStyle } from '../constants/LiveStyle';
import { EnvVm } from '../../vm/EnvVm';
import { DropdownVm } from '../../vm/DropdownVm';
import { AppForegroundEvent, AppLifeCycleManager } from '../../manager/AppLifeCycleManager';
import { CheckStage, SwipeAppToCapsuleAnimation } from '../../animation/SwipeAppToCapsuleAnimation';
import { NodeControllerManager } from '../../framenode/NodeControllerManager';
import { BannerVm } from '../../vm/BannerVm';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import { SystemUICcmConfig } from '../../utils/SystemUICcmConfig';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';
import { BannerPanelType } from '../../banner/common/info/BannerState';
import { SysTypeCode, HandleType } from '../../liveview/common/LiveConstants';
import { LiveCapsuleAnimation } from '../animation/LiveCapsuleAnimation';
import { ILiveMetaBallVisibleVm } from '../interface/ILiveMetaBallVisibleVm';
import { ClickNotificationMaintenance } from '../../maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '../../maintenance/StatisticsConstants';
import { Lifecycle, LiveHiSysEvent } from '../sysEvent/LiveHiSysEvent';
import { AnimationBase } from '../../animation/AnimationBase';
import { LiveVmInjector } from '../LiveVmInjector';
import { PipSceneManager } from '../../manager/PipSceneManager';
import { SystemEffectVm } from '../../vm/SystemEffectVm';
import { scbStatusBarStatusManager } from '../../statusbar/ScbStatusBarStatusManager';
import { StartAppOneMirrorAnimation } from '../../animation/StartAppOneMirrorAnimation';
import { LogWithHa } from '../../maintenance/CommonExceptionMaintenance';
import { LiveExceptionCode } from '../constants/LiveExceptionCode';
import { sharedData } from '../../model/SendableData';
import { DeviceRotateVm } from '../../vm/DeviceRotateVm';
import { ICapsuleKeepShowingVm } from '../interface/ICapsuleKeepShowingVm';
import { bannerMgr } from '../../banner/phone/BannerManager';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import { WindowAdapter } from '../../adapter/WindowAdapter';
import { SwipeAppToCapsuleAnimationAdapter } from '../../adapter/SwipeAppToCapsuleAnimationAdapter';
import { AppIndexInfo, PipSceneManagerAdapter } from '../../adapter/PipSceneManagerAdapter';
import { appManager } from '@kit.AbilityKit';
import { StatusBarViewControllerAdapter } from '../../adapter/StatusBarViewControllerAdapter';
import type { CapsuleAppInfo } from '../../animation/SwipeAppToCapsuleAnimation';
import { ShowStage } from '../interface/ILiveCapsuleFaceLockVm';

const TAG = 'LiveCapsuleListVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class LiveCapsuleListVm extends LiveBaseVm implements ILiveCapsuleListVm {
  public cutoutVm: CutoutVm = CutoutVm.instance;
  public dropdownVm = DropdownVm.instance;
  public envVm = EnvVm.instance;
  public bannerVm = BannerVm.instance;
  public deviceInfoVm = DeviceInfoVm.instance;
  public deviceRotateVm = DeviceRotateVm.instance;
  public viewManager = new NodeControllerManager();
  @Trace public readonly liveList: NotificationArray<LiveNotification> = new NotificationArray();
  @Trace public position: StatusBarCapsulePosition = new StatusBarCapsulePosition();
  public positionChangeCallback?: CapsulePositionChangeCallback;
  public statusBarChangeCallback?: StatusBarChangeCallback;
  public isInterruptInstantBanner: boolean = false;
  public isToEnterAppByClickCard: boolean = false;
  public isToEnterAppByClickCapsule: boolean = false;
  public enterApplicationName: string | undefined = undefined;
  /**
   * 胶囊动效计算，不为0则胶囊处于动效中
   */
  @Trace public capsuleAnimationCount: number = 0;
  @Trace public isIconFreeze: boolean = false;
  @Trace public shadowColor: string = this.getShadowColor();
  @Trace public isShowCapsule: boolean = false;
  private capsuleKeepShowingVm = this.vmInjector.getCapsuleKeepShowingVm();
  private exeDelayPromise?: CustomPromise<void>;
  private uniqueToggleFlag: boolean = true;

  @Monitor('envVm.statusBarColor')
  onColorChange() {
    // 三个及以上存在胶囊阴影时才进行动效
    if (this.liveList.length > 2) {
      const animation = new AnimationBase(AnimationBase.NAMES.LIVE_SHADOW_CAPSULE_ANIMATION, true);
      animation.executeAnimation([{
        duration: 350,
        curve: Curve.EaseOut,
        event: () => {
          this.shadowColor = this.getShadowColor();
        }
      }]);
      return;
    }
    this.shadowColor = this.getShadowColor();
  }

  private getShadowColor(): string {
    const statusBarContentColor = EnvVm.instance.statusBarColor;
    const startIdx: number = statusBarContentColor.length > 6 ? statusBarContentColor.length - 6 : 1;
    const rgbColor: string = statusBarContentColor.substring(startIdx);
    const backGroundColor: string = '#4D' + rgbColor;
    log.showInfo(`shadow capsule color = ${backGroundColor}`);
    return backGroundColor;
  }

  public async capsuleLayoutRefresh(): Promise<void> {
    log.showInfo(`capsuleLayoutRefresh ${this.cutoutVm.isMiddleCutout()}`);
    if (this.cutoutVm.isMiddleCutout()) {
      await this.middleCutoutCapsuleLayoutComputed();
    } else {
      this.capsuleLayoutComputed();
    }
  }

  /**
   * 中挖孔胶囊布局刷新
   */
  private async middleCutoutCapsuleLayoutComputed(): Promise<void> {
    // 胶囊布局重计算,针对双端挂孔胶囊，需要带动效重计算布局
    this.layoutVm.computeCapsuleFixedWithAndOffset(this.liveList, false);
    const liveDoubleEnded = this.liveList.find((live) => {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      if (capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
        return true;
      }
      return false;
    })
    if (liveDoubleEnded && !this.isToEnterAppByClickCard) {
      await this.animateToLayoutViewForUpdate(liveDoubleEnded);
    } else {
      this.setCapsuleValAfterDisplayChange();
      this.onCapsulePositionChange();
    }
  }

  /**
   * 非中挖孔胶囊布局刷新
   */
  protected async capsuleLayoutComputed(): Promise<void> {
    this.layoutVm.computeCapsuleFixedWithAndOffset(this.liveList);
    this.setCapsuleValAfterDisplayChange();
    this.onCapsulePositionChange(LiveCapsuleLayoutScene.UPDATE);
  }

  /**
   * 胶囊区域变化时，需要是否超出状态栏给的区域，超出后需要回调状态栏
   * @returns
   */
  private onCapsulePositionChange(scene: LiveCapsuleLayoutScene = LiveCapsuleLayoutScene.SHOW_HIDE,
    delay: number = 0, needAnimation?: boolean): void {
    const capsulePosition = this.position;

    if (!capsulePosition) {
      log.showInfo(`onCapsulePositionChange capsulePosition is null`);
      return;
    }

    let offsetLeft = 0;
    let offsetRight = 0;
    let isCapsuleShow = false;
    const layoutInfo = new LiveCapsuleLayoutInfo();
    for (const live of this.liveList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      if (!layoutInfo.hasCapsuleShow && capsuleVm.isVisible) {
        layoutInfo.hasCapsuleShow = true;
      }
      if ((live.isInstant() || live.isFlip()) && capsuleVm.isRemindShow) {
        // 存在【及时】或【长时】胶囊显示时，只传递给状态栏该胶囊的offset
        layoutInfo.isInstantOrPersistentShowing = true;
        // 修复抢占类胶囊与通知图标间隙不对
        if (offsetLeft === 0) {
          offsetLeft = capsuleVm.offsetX;
        }
        offsetLeft = Math.min(offsetLeft, capsuleVm.offsetX); // 及时、长时显示场景，就以其坐标作为offset
        offsetRight = Math.max(offsetRight, capsuleVm.offsetX + capsuleVm.width);
        isCapsuleShow = true;
        break;
      }

      if (capsuleVm.isShow && capsuleVm.opacity !== 0) {
        // 左侧获取所有胶囊中偏移值最小的那个
        if (offsetLeft === 0) {
          offsetLeft = capsuleVm.offsetX;
        } else {
          offsetLeft = Math.min(offsetLeft, capsuleVm.offsetX);
        }
        // 右侧获取所有胶囊中偏移值最大的
        offsetRight = Math.max(offsetRight, capsuleVm.offsetX + capsuleVm.width);
        isCapsuleShow = true;
      }
    }
    const gapBetweenCapsuleAndStatusBarLeft: number = isCapsuleShow ? this.getCapsuleStatusbarGap(true) : 0;
    const gapBetweenCapsuleAndStatusBar: number = isCapsuleShow ? this.getCapsuleStatusbarGap() : 0;
    log.showInfo(`Capsule offsetLeft: ${offsetLeft}, offsetRight: ${offsetRight},` +
      ` capsulePosition.left ${capsulePosition.left}, ${gapBetweenCapsuleAndStatusBarLeft} ${gapBetweenCapsuleAndStatusBar},` +
      ` scene ${scene}, delay: ${delay}, needAnimation: ${needAnimation}`);
    if (this.cutoutVm.isMiddleCutout()) {
      offsetLeft -= gapBetweenCapsuleAndStatusBarLeft
      offsetRight += gapBetweenCapsuleAndStatusBar
    }
    layoutInfo.left = capsulePosition.left + offsetLeft;
    layoutInfo.right = capsulePosition.left + offsetRight;

    layoutInfo.scene = scene;
    layoutInfo.delay = delay;
    layoutInfo.needAnimation = needAnimation;
    this.positionChangeCallback?.(layoutInfo);
    return;
  }

  private getCapsuleStatusbarGap(isLeft: boolean = false): number {
    if (!this.cutoutVm.isMiddleCutout()) {
      return isLeft ? LiveStyle.CAPSULE_LEFT_STATUS_BAR_GAP_WITHOUT_HOLE :
      LiveStyle.CAPSULE_STATUS_BAR_GAP_WITHOUT_HOLE;
    }

    return this.cutoutVm.holes.length === 1 ? LiveStyle.CAPSULE_STATUS_BAR_GAP_SINGLE_HOLE :
    LiveStyle.CAPSULE_STATUS_BAR_GAP_MULTI_HOLE;
  }

  @Computed
  get layoutVm() {
    return this.vmInjector.getCapsuleListLayoutVm();
  }

  @Computed
  get animVm() {
    return this.vmInjector.getCapsuleListAnimVm();
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
  get remindVm() {
    return this.vmInjector.getLiveRemindVm();
  }

  init(position: StatusBarCapsulePosition, changeCallback: CapsulePositionChangeCallback,
    statusBarChangeCallback: StatusBarChangeCallback): void {
    this.position = position;
    this.positionChangeCallback = changeCallback;
    this.statusBarChangeCallback = statusBarChangeCallback;
    AppLifeCycleManager.instance.emitter.on('appForegroundStateChanged', this.onAppForegroundStateChange);
    SwipeAppToCapsuleAnimationAdapter.registerCheckerStageCallback({ callback: this.onCheckAppToCapsuleStage },
      `${TAG}_registerCheckerStageCallback`);
    SwipeAppToCapsuleAnimationAdapter.setCapsulePosition(position);
    BannerVm.instance.emitter.on('bannerTypeChange', this.onBannerTypeChange);
  }

  async initLiveList(liveList: LiveNotification[]): Promise<void> {
    log.showWarn(`Init live list, old live number: ${this.liveList.length}, current live number: ${liveList.length}`);
    if (this.liveList.length === 0 && liveList.length === 0) {
      // 一键清除场景，如果清除前后都不存在实况，则不执行后续流程，避免冗余动效
      return;
    }

    if (this.liveList.length && this.isSameShowCapsule(liveList, this.liveList)) {
      // 原本的显示胶囊列表没有变化,且胶囊没有收回孔时，不需要再做收孔动效
      return;
    }

    for (const live of this.liveList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      capsuleVm.isToDelete = true;
    }

    for (const newLive of liveList) {
      const oldLive = this.liveList.find((live) => live.hashCode === newLive.hashCode);
      if (oldLive) {
        const capsuleVm = this.vmInjector.getCapsuleVm(oldLive);
        capsuleVm.isToDelete = false;
      } else {
        this.liveList.push(newLive);
        const capsuleVm = this.vmInjector.getCapsuleVm(newLive);
        capsuleVm.isShowed = true;
      }
    }

    this.liveList.sortCapsuleList();
    await this.toggleCapsuleList();

    for (let i = this.liveList.length - 1; i >= 0; i--) {
      const capsuleVm = this.vmInjector.getCapsuleVm(this.liveList[i]);
      if (capsuleVm.isToDelete) {
        this.liveList.splice(i, 1);
      }
    }
  }

  private isSameShowCapsule(newLiveList: LiveNotification[], liveList: LiveNotification[]): boolean {
    if (liveList.length !== newLiveList.length) {
      return false;
    }
    if (!liveList.find(i => !newLiveList.find(live => live.hashCode === i.hashCode))) {
      // 判断显示中的胶囊是否有状态变化
      let maxShowNum = liveList[0].isScreenRecorder() ? 3 : 2;
      maxShowNum = this.cutoutVm.isMiddleCutout() ? maxShowNum : maxShowNum + 1;
      let capsuleVisible = true;
      for (let index = 0; index < maxShowNum; index++) {
        if (index < liveList.length) {
          capsuleVisible = capsuleVisible && this.vmInjector.getCapsuleVm(liveList[index]).isVisible;
        }
      }
      if (capsuleVisible) {
        log.showWarn('showing capsule has no change, return');
        return true;
      }
    }
    return false;
  }

  async addLive(live: LiveNotification): Promise<void> {
    this.setFaceLockStage(live, ShowStage.SHOW);
    this.liveList.push(live);
    this.liveList.sortCapsuleList();

    // 横幅态胶囊只需要添加到胶囊列表即可不需要执行出场动效
    if (live.isHeadsUp && !this.bannerVm.isHideCapsule() && !this.dropdownVm.isDropDown) {
      log.showInfo(`add Live is headsup, not need capsule animation`);
      const lightWaveVm = this.vmInjector.getCapsuleLightWaveVm(live);
      lightWaveVm.lightShow = SystemEffectVm.instance.isShowLightWhenExpandCapsule();
      this.vmInjector.getLiveHeadsUpVm().headsUpNtfHashCode = live.hashCode;
      LiveHiSysEvent.reportLiveLifeCycleEvent(live, 0, Lifecycle.CREATE);
      log.showWarn(`stop add capsule by banner live ${live.hashCode}`);
      return;
    }

    if (SystemEffectVm.instance.isShowLightWhenExpandCapsule()) {
      const lightWaveVm = this.vmInjector.getCapsuleLightWaveVm(live);
      lightWaveVm.lightShow = true;
    }

    this.remindVm.checkAddCapsuleScene(live);
    await this.capsuleKeepShowingVm.checkAndStartKeepShowing(live, HandleType.ADD);
    await this.toggleCapsuleList({ needAnimation: this.capsuleKeepShowingVm.getNeedAnimation(),
      isInstant: live.isInstant() });
    this.capsuleKeepShowingVm.startKeepShowingTimer(live, live.isInstant(), HandleType.ADD,
      live.isInstant() ? live.duration : this.capsuleKeepShowingVm.KEEP_SHOWING_TIME);

    if (live.isMediaPlayer()) {
      this.vmInjector.getLiveMediaPlayerVm(live).addMedia(live);
    }
    LiveHiSysEvent.reportLiveLifeCycleEvent(live, 0, Lifecycle.CREATE);
    LiveHiSysEvent.reportCapsuleNumChangeEvent(this.liveList);
  }

  async updateLiveByTimer(uid: string): Promise<void> {
    let timerLive: LiveNotification | undefined;
    for (const live of this.liveList) {
      if (live.capsule?.isTimer() && live.capsule?.timer?.uid === uid) {
        timerLive = live;
        break;
      }
    }
    if (!timerLive) {
      return;
    }
    this.animateToLayoutViewForUpdate(timerLive);
  }

  async remoteUpdateLive(live: LiveNotification): Promise<void> {
    const index = this.liveList.findIndex((item) => item.hashCode === live.hashCode);
    if (index < 0) {
      log.showWarn(`Can not find Live`);
      return;
    }
    this.liveList[index] = live;
    this.onLiveListChange();
    LiveHiSysEvent.reportLiveLifeCycleEvent(live, 0, Lifecycle.UPDATE);
    if (live.isInstant()) {
      if (!this.vmInjector.getCapsuleVm(live).isVisible) {
        // 收到即时更新，但即时已经被flip抢占不显示时，即时要重新抢占弹出
        this.liveList.remove(live.hashCode);
        this.vmInjector.getCapsuleVm(live).isShowed = false;
        this.vmInjector.updateVmByLive(live, TAG);
        await this.addLive(live);
        return;
      }
      this.setFaceLockStage(live, ShowStage.UPDATE);
      await this.animateToLayoutViewForUpdate(live);
      return;
    }

    if (live.isFlip()) {
      log.showWarn(`start update flip live ${live.hashCode}`);
      // 状态栏可见时，才有扫光动效，沉浸式下呼出不要扫光
      if (this.bannerVm.bannerType !== BannerPanelType.TYPE_LIVE_LIST) {
        const lightWaveVm = this.vmInjector.getCapsuleLightWaveVm(live);
        lightWaveVm.lightShow = true;
      }
      this.liveList.sortCapsuleList();
      this.vmInjector.getCapsuleVm(live).isShowed = false;
      this.remindVm.checkUpdateCapsuleScene(live);
      await this.capsuleKeepShowingVm.checkAndStartKeepShowing(live, HandleType.UPDATE);

      const cmds: Promise<void>[] = [
        this.toggleCapsuleList({
          isUpdateImmediately: false,
          needAnimation: this.capsuleKeepShowingVm.getNeedAnimation(),
          isInstant: live.isInstant()
        })
      ];

      if (this.remindVm.isCurrentRemindCapsule(live)) {
        if (this.envVm.isImmersive) {
          this.vmInjector.updateVmByLive(live, TAG);
        } else {
          const updatePromise = SystemUICommonUtil
            .sleep(LiveStyle.METABALL_HIGHEST_DURATION)
            .then(() => {
              this.vmInjector.updateVmByLive(live, TAG);
            });
          cmds.push(updatePromise);
        }
      }

      await Promise.all(cmds);
      this.capsuleKeepShowingVm.startKeepShowingTimer(live, live.isFlip(), HandleType.UPDATE);
      return;
    }

    if (live.isExpand()) {
      log.showWarn(`start update expand live ${live.hashCode}`);
      this.liveList.sortCapsuleList();
      await SystemUICommonUtil.sleep(LiveStyle.METABALL_HIGHEST_DURATION) // 待胶囊入孔后刷新胶囊相关vm数据
      if (this.vmInjector.getLiveHeadsUpVm().isHiding) {
        // 横幅正在做hide动效，等待动效结束再刷新胶囊vm
        await SystemUICommonUtil.sleep(650);
      }
      this.vmInjector.updateVmByLive(live, TAG);
      this.vmInjector.getCapsuleMarqueeVm(live).updateUIProperty();
      return;
    }

    if (this.remindVm.getCurrentRemindCapsule()) {
      if (this.remindVm.getCurrentRemindCapsule()?.hashCode !== live.hashCode) {
        log.showWarn('capsule is in remind, not need update other live');
        return;
      }
      log.showInfo('capsule is in remind, updateRemindLive');
      this.vmInjector.updateVmByLive(live, TAG);
      this.layoutVm.setRemindCapsuleWidth(live, true);
      const animation = new LiveCapsuleAnimation(live, this.vmInjector);
      this.onCapsulePositionChange(LiveCapsuleLayoutScene.SHOW_HIDE, 30);
      await animation.updateRemindAnimation();
      return;
    }

    if (this.vmInjector.getLiveHeadsUpVm().headsUpNtfHashCode === live.hashCode) {
      log.showWarn(`banner is showing, hashcode = ${live.hashCode}`);
      return;
    }

    if (live.isMediaPlayer()) {
      this.vmInjector.getLiveMediaPlayerVm(live).updateMedia(live);
      await this.animateToLayoutViewForUpdate(live);
      return;
    }

    await this.animateToLayoutViewForUpdate(live);
  }

  private setFaceLockStage(live: LiveNotification, stage: ShowStage): void {
    if (!live.isFaceLock()) {
      return;
    }
    const capsuleFaceLockVm =  this.vmInjector.getLiveCapsuleFaceLockVm(live);
    log.showWarn(`${live.hashCode} isFaceLock start set stage: ${stage}, ${capsuleFaceLockVm.isOnTree}`);
    capsuleFaceLockVm.showStage = stage;
    if (stage === ShowStage.SHOW) {
      //连续创建胶囊, repeat组件会复用缓存, 需要主动调用一下
      SystemUICommonUtil.sleep(30).then(()=> {
        if (!capsuleFaceLockVm.isOnTree) {
          capsuleFaceLockVm.showFaceLock();
        }
      })
      return;
    }
    if (stage === ShowStage.UPDATE) {
      capsuleFaceLockVm.showFaceLock(true);
      return;
    }
    if (stage === ShowStage.HIDE) {
      capsuleFaceLockVm.hideFaceLock();
      return;
    }
  }

  /**
   * 动效更新布局视图
   */
  public async animateToLayoutViewForUpdate(live: LiveNotification): Promise<void> {
    log.showInfo('animateToLayoutViewForUpdate start')
    if (this.deviceRotateVm.rotationPromise) {
      log.showWarn(`deviceRotateVm rotationPromise is start await resolve`);
      await Promise.race([
        this.deviceRotateVm.rotationPromise,
        SystemUICommonUtil.sleep(2000),
      ]);
      log.showWarn(`deviceRotateVm rotationPromise is resolve`);
    }
    return new Promise<void>((resolve) => {
      // 在宏任务中执行动效规避V2动效bug
      setTimeout(async () => {
        log.showInfo('animateToLayoutViewForUpdate animate start');
        this.layoutVm.computeCapsuleFixedWithAndOffset(this.liveList, false);
        const promise = this.animVm.updateCapsuleWidthAndOffset(this.liveList, live);
        this.onCapsulePositionChange(LiveCapsuleLayoutScene.UPDATE);
        await promise;
        this.setMarqueeState(live);
        // 等待展开结束视作动效完成
        resolve();
      }, 0);
    });
  }

  async localUpdateLiveList(liveList: LiveNotification[]): Promise<void> {
    for (const live of liveList) {
      const index = this.liveList.findIndex((item) => item.hashCode === live.hashCode);
      if (index < 0) {
        log.showInfo(`localUpdate Can not find Live`);
        continue;
      }
      this.liveList[index] = live;
      LiveHiSysEvent.reportLiveLifeCycleEvent(live, 0, Lifecycle.UPDATE);
    }
    this.layoutVm.computeCapsuleFixedWithAndOffset(this.liveList);
    await this.animVm.updateCapsuleWidthAndOffset(this.liveList);
  }

  async removeLiveList(liveList: LiveNotification[]): Promise<void> {
    for (const live of liveList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      capsuleVm.isToDelete = true;
      if (this.remindVm.isCurrentRemindCapsule(live)) {
        this.remindVm.clearRemindCapsule();
      }
    }
    log.showWarn(`start toggle before remove capsule live, capsule liveList length: ${this.liveList.length}`);
    this.uniqueToggleFlag = false;
    await this.toggleCapsuleList();
    this.uniqueToggleFlag = true;
    const lifecycleVm = this.vmInjector.getCapsuleLifecycleVm();
    for (const live of liveList) {
      log.showWarn(`start remove live ${live.hashCode}`);
      this.liveList.remove(live.hashCode);
      LiveHiSysEvent.reportLiveLifeCycleEvent(live, lifecycleVm.getCapsuleShowTime(live.id), Lifecycle.DELETE);
      lifecycleVm.deleteLifecycleInfo(live.id);
      LogWithHa.info(log, `remove capusle live from liveList ${live.hashCode}`);
      this.setFaceLockStage(live, ShowStage.HIDE);
    }
    if (this.liveList.length === 0) {
      this.onCapsulePositionChange(LiveCapsuleLayoutScene.SHOW_HIDE, 0, false);
    }
    log.showWarn(`remove capsule live end, capsule liveList length: ${this.liveList.length}`);
  }

  /**
   * 计算布局并切换列表形态
   *
   * @param capsuleTransferParam 胶囊动效参数
   */
  public async toggleCapsuleList(capsuleTransferParam?: CapsuleTransferParam): Promise<void> {
    log.warn('start to toggleCapsuleList, param: ', capsuleTransferParam);
    // 如果旋转场景，等待旋转结束再做融球和胶囊动效
    const startTime = Date.now();
    if (this.deviceRotateVm.rotationPromise) {
      log.showWarn(`deviceRotateVm rotationPromise is start await resolve`);
      await Promise.race([
        this.deviceRotateVm.rotationPromise,
        SystemUICommonUtil.sleep(10000),
      ]);
      log.showWarn(`deviceRotateVm rotationPromise is resolve`);
    }
    const interval = Date.now() - startTime;
    if (interval >= 9000) {
      log.showWarn(`rotate is block in ${startTime}`);
      LogWithHa.error(log, `rotate is block in ${startTime}`, LiveExceptionCode.ROTATE_BLOCK);
    }
    this.remindVm.checkCurrentRemindScene();
    if (!this.checkAllVisibleChanged()) {
      log.showWarn(`Visible is not changed, stop toggleCapsuleList.`);
      return;
    }
    const needAnimation = capsuleTransferParam?.needAnimation ?? true;
    // 沉浸式不调用动效
    if (!needAnimation) {
      log.showWarn('toggleCapsuleList not need animation');
      this.layoutVm.computeCapsuleFixedWithAndOffset(this.liveList, true);
      this.switchToLayoutView();
      this.setMarqueeState();
      this.onCapsulePositionChange(LiveCapsuleLayoutScene.SHOW_HIDE, 0, false);
      scbStatusBarStatusManager.showStatusbarByLiveCapsule();
      this.vmInjector.getCapsuleLifecycleVm().updateCapsuleShow(this.liveList);
      return;
    }
    // 布局
    this.layoutVm.computeCapsuleFixedWithAndOffset(this.liveList, capsuleTransferParam?.isUpdateImmediately);
    // 状态栏动效
    this.statusBarChangeCallback?.();
    // 胶囊动效
    await this.animateToLayoutView(capsuleTransferParam);
    // 设置跑马灯状态
    this.setMarqueeState();
    this.vmInjector.getCapsuleLifecycleVm().updateCapsuleShow(this.liveList);
  }

  public getShowCapsuleListNum(isCountCapsuleHidden?: boolean): number {
    let num = 0;
    for (const live of this.liveList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      if (!capsuleVm.isShow && !isCountCapsuleHidden) {
        continue;
      }
      if (live.isScreenRecorder() && capsuleVm.fixedShowType !== CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
        continue;
      }
      num += 1;
    }
    return num;
  }

  /**
   * 融球重新上树处理逻辑，包括：
   * 1. 融球状态刷新为当前胶囊数对应状态
   * 2. 胶囊从孔中弹出
   * @returns
   */
  private async onMetaBallAppear(): Promise<void> {
    // 布局
    this.layoutVm.computeCapsuleFixedWithAndOffset(this.liveList);
    // 状态栏动效
    this.statusBarChangeCallback?.();
    // 胶囊动效
    setTimeout(async () => {
      // 融球动效
      this.capsuleAnimationCount++;
      this.metaBallVm.toggleState();
      this.animVm.setCapsuleTransferState();
      const promise = this.animVm.expandCapsuleList();
      this.onCapsulePositionChange(LiveCapsuleLayoutScene.SHOW_HIDE, LiveStyle.METABALL_HIGHEST_DURATION + 34);
      await promise;
      this.capsuleAnimationCount--;
      this.setMarqueeState();
    }, 0);
  }

  /**
   * 检查所有胶囊的显隐
   * @returns 如果有某个胶囊显隐状态变化则返回true
   */
  private checkAllVisibleChanged(): boolean {
    let changed = false;
    this.isShowCapsule = false;
    for (const live of this.liveList) {
      changed = this.checkItemVisibleChanged(live) || changed;
    }

    if (changed) {
      return true;
    }

    // 长时、强提醒退场场景
    const hasRemindShow = this.liveList.find((live) => {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      return capsuleVm.isRemindShow;
    });
    if (hasRemindShow && !this.remindVm.getCurrentRemindCapsule()) {
      log.showInfo(`remind capsule has to exit`);
      return true;
    }

    // 强提醒出场场景
    const isFlipShow = this.liveList.find((live) => {
      if (live.isFlip()) {
        const capsuleVm = this.vmInjector.getCapsuleVm(live);
        return !capsuleVm.isShowed && this.remindVm.isCurrentRemindCapsule(live);
      }

      return false;
    });
    if (isFlipShow) {
      log.showInfo(`capsule FLIP start`);
      return true;
    }

    return false;
  }

  /**
   * 检查单个胶囊的显隐
   * @param live
   * @returns 返回胶囊显示结果是否变化，变化则返回true
   */
  protected checkItemVisibleChanged(live: LiveNotification): boolean {
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    const oldVisible = capsuleVm.isVisible;

    if (capsuleVm.isToDelete) {
      log.showWarn(`Capsule ${live.hashCode} is toDelete`);
      capsuleVm.isVisible = false;
    } else if (this.deviceInfoVm.isEmergencyMode()) {
      log.showWarn(`Capsule ${live.hashCode} is in EmergencyMode: ${this.deviceInfoVm.deviceMode}`);
      capsuleVm.isVisible = false;
    } else if (live.isInstant()) {
      const remind = this.remindVm.getCurrentRemindCapsule()?.hashCode;
      log.showWarn(`Capsule ${live.hashCode} is Instant, remind: ${remind}`);
      capsuleVm.isVisible = live.hashCode === remind;
    } else if (this.dropdownVm.isDropDown) {
      log.showWarn(`Capsule ${live.hashCode} Dropdown is show`);
      capsuleVm.isVisible = false;
    } else if (this.bannerVm.isHideCapsule()) {
      log.showWarn(`Capsule ${live.hashCode} Banner is show liveCardList`);
      capsuleVm.isVisible = false;
    } else if (this.envVm.isScreenLock) {
      log.showWarn(`Capsule ${live.hashCode} Screen is locked`);
      capsuleVm.isVisible = false;
    } else if (this.vmInjector.getLiveHeadsUpVm().headsUpNtfHashCode === live.hashCode) {
      log.showWarn(`Capsule ${live.hashCode} Banner is show headsUp`);
      capsuleVm.isVisible = false;
    } else if (AppLifeCycleManager.instance.isForeground(live.creatorUid, live) && !live.capsule?.sticky) {
      log.showWarn(`Capsule ${live.hashCode} App ${live.creatorBundleName}_${live.creatorUid} is foreground`);
      capsuleVm.isVisible = false;
    } else if (this.remindVm.getCurrentRemindCapsule()) {
      const remind = this.remindVm.getCurrentRemindCapsule()?.hashCode;
      log.showWarn(`Capsule ${live.hashCode} is in remind scene, remind: ${remind}`);
      capsuleVm.isVisible = live.hashCode === remind;
    } else if (this.isInterruptInstantBanner) {
      log.showWarn(`Capsule ${live.hashCode} need hide by click when instant banner is interrupt`);
      capsuleVm.isVisible = false;
    } else {
      capsuleVm.isVisible = true;
    }

    if (capsuleVm.isVisible) {
      this.isShowCapsule = true;
    }

    const changed = capsuleVm.isVisible !== oldVisible;
    log.showWarn(`Check item visible for ${live.hashCode}, result: ${capsuleVm.isVisible}, changed: ${changed}`);

    return changed;
  }

  /**
   * 动效更新布局视图
   */
  private async animateToLayoutView(capsuleTransferParam?: CapsuleTransferParam): Promise<void> {
    return new Promise<void>((resolve) => {
      this.capsuleAnimationCount++;

      // 在宏任务中执行动效规避V2动效bug
      setTimeout(async () => {
        log.showWarn('animateToLayoutView start');
        const promise = this.animVm.setCapsuleListFinalState(capsuleTransferParam);
        this.statusBarLinkAction(capsuleTransferParam);
        if (SystemEffectVm.instance.isShowLightWhenExpandCapsule()) { //是否开启胶囊扫光
          this.animVm.expandLightWave(capsuleTransferParam);
        }
        // 融球动效
        this.metaBallVm.toggleState(capsuleTransferParam);
        await promise;
        log.showWarn('animateToLayoutView finish');
        // 等待展开结束视作动效完成
        this.capsuleAnimationCount--;
        resolve();
      }, 0);
    });
  }

  private statusBarLinkAction(capsuleTransferParam?: CapsuleTransferParam): void {
    if (!this.cutoutVm.isMiddleCutout()) {
      // 横屏点击胶囊展开/收回卡片联动动效
      const needAnimation = !capsuleTransferParam?.onlyChangeOpacity;
      this.onCapsulePositionChange(LiveCapsuleLayoutScene.SHOW_HIDE, this.getCapsuleChangeDelay(), needAnimation);
      return;
    }
    // 竖屏状态栏联动动效
    const needAnimation = !capsuleTransferParam?.onlyChangeOpacity;
    this.onCapsulePositionChange(LiveCapsuleLayoutScene.SHOW_HIDE, 290, needAnimation);
  }

  protected getCapsuleChangeDelay(): number {
    if (DropdownVm.instance.checkShowDropDownType) {
      return this.remindVm.getCurrentRemindCapsule() ? 0 : 250;
    }

    return this.bannerVm.isHideCapsule() ? 110 : 0;
  }

  /**
   * 非动效更新视图布局
   */
  private switchToLayoutView() {
    for (const live of this.vmInjector.getCapsuleListVm().liveList) {
      const capsule = this.vmInjector.getCapsuleVm(live);
      const marqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
      const lightWaveVm = this.vmInjector.getCapsuleLightWaveVm(live);
      marqueeVm.isRunning = false;
      marqueeVm.isExtendRunning = false;
      marqueeVm.radius = 0;
      marqueeVm.isBuildScoreText = capsule.isScoreScene(live);
      // 沉浸式胶囊一帧显示不扫光
      lightWaveVm.lightShow = false;
      if (capsule.isShow) {
        if (live.isInstant()) {
          capsule.isRemindShow = !capsule.isShowed;
        } else {
          capsule.isRemindShow = this.remindVm.isCurrentRemindCapsule(live);
        }

        //非挂孔圆饼胶囊
        capsule.setCakeShowVal();
        capsule.isShowed = true;

        capsule.showType = capsule.fixedShowType;
        const isRoundCake = capsule.showType === CapsuleShowType.ROUND_CAKE;
        const isShadow = capsule.showType === CapsuleShowType.SHADOW;
        capsule.zIndex = LiveStyle.CAPSULE_INDEX;
        capsule.width = capsule.fixedWidth;
        capsule.updateLinearGradient();
        capsule.offsetX = capsule.fixedOffsetX;
        capsule.scaleX = 1;
        capsule.scaleY = 1;
        capsule.offsetY = 0;
        capsule.opacity = 1;
        capsule.blur = 0;
        capsule.contentScaleX = 1;
        capsule.contentScaleY = 1;
        capsule.contentOpacity = 1;
        capsule.backgroundColor = undefined;
        capsule.disableOutline = false;
        capsule.isShowRightIcon = capsule.fixedIsShowRightIcon;
        if (isRoundCake) {
          capsule.zIndex = LiveStyle.CAPSULE_ROUND_CAKE_INDEX;
        }
        if (isShadow) {
          capsule.zIndex = LiveStyle.CAPSULE_LOW_INDEX;
        }
        LiveHiSysEvent.reportCapsuleShow(live);
      } else {
        capsule.width = LiveStyle.CAPSULE_CIRCLE_WIDTH;
        capsule.offsetX = 0;
        capsule.offsetY = 0;
        capsule.scaleX = 1;
        capsule.scaleY = 1;
        capsule.opacity = 0;
        capsule.blur = 0;
        capsule.zIndex = LiveStyle.CAPSULE_LOW_INDEX;
        capsule.isRemindShow = false;
      }
    }
    this.layoutVm.capsuleListWidth = this.layoutVm.capsuleListFixedWidth;
    this.metaBallVm.toggleState({ metaBallToggleDuration: 0 })
  }

  private setCapsuleValAfterDisplayChange(): void {
    log.showWarn(`setCapsuleValAfterDisplayChange: ${scbStatusBarStatusManager.getNeedStatusBarKeepShowing()}`);
    // 长时在接续
    if (scbStatusBarStatusManager.getNeedStatusBarKeepShowing()) {
      return;
    }
    for (const live of this.liveList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);

      log.showWarn(`live: ${live.hashCode} showType: ${capsuleVm.showType} fixedShowType: ${capsuleVm.fixedShowType}`);
      capsuleMarqueeVm.radius = 0;
      capsuleMarqueeVm.isRunning = false;
      capsuleMarqueeVm.isExtendRunning = false;
      if (capsuleVm.fixedShowType === CapsuleShowType.NONE) {
        capsuleVm.zIndex = LiveStyle.CAPSULE_LOW_INDEX;
        continue;
      }
      capsuleVm.showType = capsuleVm.fixedShowType;
      // 更新一下形态
      capsuleVm.setCakeShowVal();
      capsuleVm.scaleX = 1;
      capsuleVm.scaleY = 1;
      capsuleVm.opacity = capsuleVm.fixedWidth > 0 ? 1 : 0;
      capsuleVm.width = capsuleVm.fixedWidth;
      capsuleVm.updateLinearGradient();
      capsuleVm.offsetX = capsuleVm.fixedOffsetX;
    }
    this.setMarqueeState();
    this.layoutVm.capsuleListWidth = this.layoutVm.capsuleListFixedWidth;
  }

  /**
   * 抢占类胶囊接续
   * @param live
   */
  private async remindCapsuleKeepShow(live: LiveNotification): Promise<void> {
    this.layoutVm.setRemindCapsuleWidth(live, true);
    this.layoutVm.capsuleListWidth = this.layoutVm.capsuleListFixedWidth;
    if (!(await WindowAdapter.isViewShowing(ViewType.STATUS_BAR))) {
      WindowAdapter.showView(ViewType.STATUS_BAR);
    }
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    capsuleVm.offsetX = capsuleVm.fixedOffsetX;
    capsuleVm.width = capsuleVm.fixedWidth;
    capsuleVm.updateLinearGradient();
    capsuleVm.showType = capsuleVm.fixedShowType;
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
    capsuleMarqueeVm.isMarqueeEnabled = capsuleMarqueeVm.fixedIsMarqueeEnabled;
    capsuleMarqueeVm.isExtendTextMarqueeEnabled = capsuleMarqueeVm.fixedIsExtendTextMarqueeEnabled;
    const waveVm = this.vmInjector.getCapsuleLightWaveVm(live);
    waveVm.lightShow = false;
    // 接续场景要触发一下状态栏重布局，避免旋转过程中状态栏图标显隐计算使用横屏状态下胶囊布局，导致计算错误
    this.onCapsulePositionChange(LiveCapsuleLayoutScene.SHOW_HIDE, 0, false);
    log.showInfo(`remindCapsuleKeepShow: ${capsuleVm.fixedOffsetX}, ${capsuleVm.offsetX}, ${capsuleVm.fixedWidth}, ${capsuleVm.width}, ${capsuleVm.fixedShowType}`);
  }

  private findShowingPersistentCapsule(): LiveNotification | undefined {
    // 找到列表中正在做伸展动效的抢占类胶囊
    for (const live of this.liveList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      if (capsuleVm.isRemindShow) {
        return live;
      }
    }
    return undefined;
  }

  public onDropdownShowChange(): void {
    log.showWarn(`ondropdownShowChange: ${this.dropdownVm.isDropDown},oneMirrorAnimating: ${this.dropdownVm.oneMirrorAnimating} isMiddleCutout:${this.cutoutVm.isMiddleCutout()}`);
    // 中挖孔场景需等待一镜到底动效执行完毕才响应下拉变化事件
    if(this.cutoutVm.isMiddleCutout() && this.dropdownVm.oneMirrorAnimating) {
      return;
    }
    this.isInterruptInstantBanner = false;
    this.metaBallVm.setScene(LiveMetaBallScene.DROPDOWN, this.dropdownVm.isDropDown);
    this.toggleCapsuleList({ needAnimation: true });
    // 无孔场景下 有及时胶囊的时候需要触发一次胶囊的布局变更
    if (!this.cutoutVm.isMiddleCutout() && this.liveList.some(live => live.isInstant)) {
      log.showInfo(`Drop down,Capsule position change!`)
      this.onCapsulePositionChange(LiveCapsuleLayoutScene.SHOW_HIDE, 0, false);
    }
  }

  @Monitor('envVm.isScreenLock')
  onScreenLockChange(): void {
    log.showWarn(`onScreenLockChange: ${this.envVm.isScreenLock}, isMiddleCutout:${this.cutoutVm.isMiddleCutout()}`);
    this.handleScreenLockChange();
  }

  protected handleScreenLockChange(): void {
    this.isInterruptInstantBanner = false;
    this.metaBallVm.setScene(LiveMetaBallScene.SCREEN_LOCK, this.envVm.isScreenLock);
    if (this.cutoutVm.isMiddleCutout()) {
      // 避免应用在前台时直接锁屏再亮屏时与应用前后台切换事件冲突，触发的融球动效异常
      setTimeout(() => {
        this.toggleCapsuleList();
      }, 50);
    } else {
      this.toggleCapsuleList({ needAnimation: false });
    }
  }

  @Monitor('deviceInfoVm.deviceMode')
  onDeviceModeChange(): void {
    log.showWarn(`onDeviceModeChange: ${this.deviceInfoVm.deviceMode}`);
    this.isInterruptInstantBanner = false;
    this.toggleCapsuleList();
  }

  public onBannerTypeChange = (): void => {
    this.metaBallVm.setScene(LiveMetaBallScene.LIVE_PANEL, this.bannerVm.isHideCapsule());
  };

  public onCutoutChange(): void {
    let targetPersistentCapsule = this.findShowingPersistentCapsule();
    scbStatusBarStatusManager.setNeedStatusBarKeepShowing(targetPersistentCapsule !== undefined);
    this.layoutVm.computeCapsuleFixedWithAndOffset(this.liveList);
    log.showWarn(`onCutoutDisplayChange,top: ${this.cutoutVm.top}, capsulePosition:L-${this.position?.capsuleLeftMin},R-${this.position?.capsuleRightMax},
     needStatusBarKeepShowing: ${scbStatusBarStatusManager.getNeedStatusBarKeepShowing()}`);
    if (targetPersistentCapsule !== undefined) {
      log.showWarn(`onCutoutDisplayChange-time: ${targetPersistentCapsule.duration}`);
      this.remindCapsuleKeepShow(targetPersistentCapsule);
      return;
    }
    if (this.cutoutVm.isMiddleCutout()) { // 从其他状态变为中挖孔，需做特殊处理
      this.onCutoutDisplayChangeToMiddle();
    } else { // 变化到其他状态直接刷新UI，不能直接调用toggle，因为旋转不改变胶囊visible
      this.switchToLayoutView();
      this.setMarqueeState();
      this.onCapsulePositionChange(LiveCapsuleLayoutScene.SHOW_HIDE, 0, false);
    }
  };

  private async onCutoutDisplayChangeToMiddle(): Promise<void> {
    const showCapsuleNum = this.getShowCapsuleListNum();
    log.showWarn(`onCutoutDisplayChangeToMiddle, showCapsuleNum: ${showCapsuleNum}, isToEnterApplication: ${this.isToEnterAppByClickCard}`);
    if (showCapsuleNum === 0) {
      this.onCapsulePositionChange(LiveCapsuleLayoutScene.SHOW_HIDE, 0, false);
      log.showInfo(`onCutoutDisplayChangeToMiddle return, capsule num = ${showCapsuleNum}`);
      return;
    }

    if (this.isToEnterAppByClickCard) {
      this.capsuleLayoutComputed();
      log.showInfo(`onCutoutDisplayChangeToMiddle return, isToEnterApplication: ${this.isToEnterAppByClickCard}`);
      return;
    }

    if (this.vmInjector.getLiveDataVm().isClearAllApp) {
      this.capsuleLayoutComputed();
      log.showInfo('onCutoutDisplayChangeToMiddle is clearAllApp return');
      return;
    }

    // 胶囊统一入孔
    this.moveAllCapsuleToHole();
    // 胶囊入孔后要触发一下状态栏重布局，避免旋转过程中状态栏图标显隐计算使用横屏状态下胶囊布局，导致计算错误
    this.onCapsulePositionChange(LiveCapsuleLayoutScene.SHOW_HIDE, 0, false);

    if (this.dropdownVm.isDropDown) {
      log.showInfo(`onCutoutDisplayChangeToMiddle is dropdown return`);
      return;
    }

    if (this.isToEnterAppByClickCapsule) {
      log.showInfo(`onCutoutDisplayChangeToMiddle is return by click capsule to enter App`);
      return;
    }

    if (this.envVm.isScreenLock) { // 小外屏内外屏切换会进入锁屏，不执行融球动效
      log.showInfo(`onCutoutDisplayChangeToMiddle is return by isScreenLock`);
      return;
    }

    // 胶囊展开为卡片列表的时候，不走融球出孔动效
    if (this.bannerVm.bannerType === BannerPanelType.TYPE_LIVE_LIST) {
      log.showInfo(`onCutoutDisplayChangeToMiddle is return by bannerType TYPE_LIVE_LIST`);
      return;
    }
    // 如果屏幕旋转过程中有抢占类胶囊在接续，不走融球出孔动效
    if (scbStatusBarStatusManager.getNeedStatusBarKeepShowing()) {
      log.showInfo(`onCutoutDisplayChangeToMiddle is return by statusBarKeepShowing`);
      return;
    }

    if (!this.liveMetaBallVisibleVm.appearPromise) {
      this.liveMetaBallVisibleVm.appearPromise = new CustomPromise();
    }
    await Promise.all([
      this.liveMetaBallVisibleVm.appearPromise,
      this.deviceRotateVm.rotationPromise
    ])
    this.onMetaBallAppear();
    this.liveMetaBallVisibleVm.appearPromise = undefined;
    this.deviceRotateVm.rotationPromise = undefined;
  };

  private moveAllCapsuleToHole(): void {
    for (const live of this.liveList) {
      const capsule = this.vmInjector.getCapsuleVm(live);
      const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
      const isRoundCake = capsule.showType === CapsuleShowType.ROUND_CAKE;
      capsule.width = LiveStyle.CAPSULE_CIRCLE_WIDTH;
      capsule.offsetX = 0;
      capsule.scaleX = 1;
      capsule.scaleY = 1.15;
      capsule.offsetY = 0;
      capsule.opacity = 0;
      capsule.contentScaleX = 0;
      capsule.contentScaleY = 0;
      capsule.contentOpacity = 0;
      capsule.backgroundColor = 'rgba(0, 0, 0, 1)';
      capsule.disableOutline = true;
      capsule.blur = 0;
      capsule.zIndex = LiveStyle.CAPSULE_INDEX;
      capsuleMarqueeVm.isBuildScoreText = capsule.isScoreScene(live);
      capsule.isShowRightIcon = capsule.fixedIsShowRightIcon;
      if (isRoundCake) {
        capsule.scaleX = 0;
        capsule.scaleY = 0;
        capsule.zIndex = LiveStyle.CAPSULE_ROUND_CAKE_INDEX;
      }
    }
  }

  private onAppForegroundStateChange = async (event: AppForegroundEvent): Promise<void> => {
    log.showWarn(`onAppForegroundStateChange foreground: ${event.isForeground}, ` +
      `uid: ${event.uid}, bundleName: ${event.bundleName}, ` +
      `orientation: ${this.deviceInfoVm.orientation}`);
    if (event.isForeground && (this.isToEnterAppByClickCard || this.isToEnterAppByClickCapsule) &&
      this.enterApplicationName === event.bundleName) {
      this.isToEnterAppByClickCard = false
      this.isToEnterAppByClickCapsule = false;
      this.enterApplicationName = undefined;
    }
    this.isInterruptInstantBanner = false;
    if (this.exeDelayPromise) {
      log.info(`need to wait delay time`);
      await this.exeDelayPromise;
    }

    if (BannerVm.instance.isLivePanel() && event.isForeground && !this.vmInjector.getSwitchVm().isCollapsing &&
      !sharedData.isExecuting) {
      log.showWarn(`CollapseCardToCapsule when ability forgeground`);
      this.vmInjector.getSwitchVm().collapseCardToCapsule();
    } else if (this.liveList.length === 1 &&
      this.liveList[0].typeCode === SysTypeCode.PHONE && event.isForeground &&
      event.uid === this.liveList[0].creatorUid && CutoutVm.instance.isMiddleCutout()) {
      // 拉起通话特殊定制
      const capsuleVm = this.vmInjector.getCapsuleVm(this.liveList[0]);
      if (capsuleVm.opacity === 0 && !this.liveList[0].capsule?.sticky) {
        log.showWarn('phone capsule has collapsed.');
        capsuleVm.isVisible = false;
        this.layoutVm.computeCapsuleFixedWithAndOffset(this.liveList);
        this.metaBallVm.toggleState({ metaBallToggleDuration: 0 });
        this.statusBarLinkAction();
      } else {
        this.toggleCapsuleList();
      }
      bannerMgr.releasePanelHeadsUp();
    } else {
      // 应用还未切到后台，点击多任务一键清除不执行胶囊动效
      if (!this.vmInjector.getLiveDataVm().isClearAllApp) {
        this.uniqueToggleFlag = true;
        // 如果是应用销毁，先等待1000ms后执行，防止销毁对应的消息删除事件触发第二次toggle
        if (event.switchAbilityState === appManager.ApplicationState.STATE_DESTROY) {
          await SystemUICommonUtil.sleep(1000);
        }
        if (this.uniqueToggleFlag) {
          const isHideHoles = systemParameterEnhance.getSync('persist.sys.graphic.hideNotch.status', '0') === '2';
          this.toggleCapsuleList({
            isUpwards: !event.isForeground && !isHideHoles,
            isUpdateImmediately: false,
            needAnimation: this.envVm.isStatusBarShow
          });
        }
      }
    }
    // 涉及胶囊的应用前后台事件打点
    const live = this.liveList.find(live => live.creatorUid === event.uid);
    if (live) {
      ClickNotificationMaintenance.reportClick(undefined, {
        data: live,
        clickRegion: event.isForeground ? ClickRegion.APP_FOREGROUND : ClickRegion.APP_BACKGROUND,
      });
    }
  };
  private onCheckAppToCapsule = (bundleName: string, appIndex: number, pipSceneAppInfo: AppIndexInfo[]): boolean => {
    log.showInfo(`onCheckAppToCapsule ${bundleName} appIndex ${appIndex}`);
    const live = this.liveList.find((live) => {
      if (!(live.creatorBundleName === bundleName && live.appIndex === appIndex)) {
        return false;
      }

      if (live.isInstant() && !this.vmInjector.getCapsuleVm(live).isRemindShow) {
        return false;
      }

      return true;
    });
    if (!live) {
      log.showInfo(`onCheckAppToCapsule has no same live, return false`);
      return false;
    }

    if (this.deviceInfoVm.isEmergencyMode()) {
      log.showInfo(`Capsule ${live.hashCode} is in EmergencyMode, return false`);
      return false;
    }

    if (live.isInstant()) {
      log.showInfo(`onCheckAppToCapsule ${live.hashCode} is instant live, return false`);
      return false;
    }

    if (this.remindVm.getCurrentRemindCapsule()) {
      log.showInfo(`onCheckAppToCapsule ${live.hashCode} is in remind, return ${this.remindVm.isCurrentRemindCapsule(live)}`);
      return this.remindVm.isCurrentRemindCapsule(live);
    }

    if (this.isPipLive(live, pipSceneAppInfo)) {
      log.showInfo(`onCheckAppToCapsule ${live.hashCode} is piplive, return false`);
      return false;
    }
    log.showWarn(`onCheckAppToCapsule return true`);
    return true;
  }

  private isPipLive(live: LiveNotification, pipSceneAppInfos: AppIndexInfo[]): boolean {
    for (const pipSceneAppInfo of pipSceneAppInfos) {
      // 非播控不处理
      if (!live.isMediaPlayer()) {
        continue;
      }

      if (live.creatorBundleName === pipSceneAppInfo.bundleName && live.appIndex === pipSceneAppInfo.appIndex) {
        return true;
      }
    }
    return false;
  }

  private onCheckAppToCapsuleStage = (checkStage: CheckStage, hashCode?: string): void => {
    if (checkStage === CheckStage.START_CHECK) {
      this.exeDelayPromise = new CustomPromise();
      return;
    }

    if (checkStage === CheckStage.END_CHECK) {
      setTimeout(() => {
        this.exeDelayPromise?.resolve();
        this.exeDelayPromise = undefined;
      }, 100);
      return;
    }

    if (checkStage === CheckStage.PHONE_CHECK) {
      const live = this.liveList.find((live) => live.hashCode === hashCode);
      if (live) {
        this.vmInjector.getCapsuleVm(live).isToDelete = true;
      }
    }
  }

  @Monitor('liveList.length')
  async onLiveListChange() {
    let capsuleAppArray: CapsuleAppInfo[] = [];
    const pipSceneAppInfo: AppIndexInfo[] = await PipSceneManagerAdapter.getPipSceneAppInfo();
    this.liveList.forEach(async (live) => {
      const result = this.onCheckAppToCapsule(live.creatorBundleName, live.appIndex, pipSceneAppInfo);
      if (result) {
        capsuleAppArray.push({
          bundleName: live.creatorBundleName,
          appIndex: live.appIndex,
          typeCode: live.typeCode,
          hashCode: live.hashCode,
        });
      }
    });

    log.showInfo(`capsuleAppArray ${capsuleAppArray.length}`);
    SwipeAppToCapsuleAnimationAdapter.setCapsuleAppArray(capsuleAppArray);
  }

  private setMarqueeState(updateLive?: LiveNotification): void {
    if (this.capsuleAnimationCount > 0) {
      // 正在做胶囊toggle动效，动效结束会重新进入。
      return;
    }
    for (const live of this.liveList) {
      const marqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
      marqueeVm.radius = 0;
      if (updateLive && updateLive.hashCode !== live.hashCode) {
        // 更新时不改变其他胶囊的跑马灯状态
        continue;
      }
      log.showInfo(`set ${live.hashCode} marquee enabled ${marqueeVm.isMarqueeEnabled} to ${marqueeVm.fixedIsMarqueeEnabled} `);
      log.showInfo(`set ${live.hashCode} extend marquee enabled ${marqueeVm.isExtendTextMarqueeEnabled} to ${marqueeVm.fixedIsExtendTextMarqueeEnabled} `);
      marqueeVm.isMarqueeEnabled = marqueeVm.fixedIsMarqueeEnabled;
      marqueeVm.isExtendTextMarqueeEnabled = marqueeVm.fixedIsExtendTextMarqueeEnabled;
      const running = this.checkMarqueeRunning(live, updateLive);
      if (!running) {
        log.showInfo(`${live.hashCode} marqueee is not running`);
        continue;
      }
      log.showWarn(`set ${live.hashCode} marquee isRunning ${marqueeVm.isRunning}`);
      marqueeVm.isRunning = true;
      marqueeVm.isExtendRunning = true;
    }
  }

  private checkMarqueeRunning(live: LiveNotification, updateLive?: LiveNotification): boolean {
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    if (updateLive) {
      if (updateLive.hashCode === live.hashCode && (capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE ||
        capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED ||
        capsuleVm.fixedShowType === CapsuleShowType.SELF_ADAPTIVE_ROUND_CAKE ||
        capsuleVm.fixedShowType === CapsuleShowType.TOP ||
        capsuleVm.fixedShowType === CapsuleShowType.RETRACTABLE_ROUND_CAKE)) {
        return true;
      }
    } else {
      if (capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE ||
        capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED ||
        capsuleVm.fixedShowType === CapsuleShowType.SELF_ADAPTIVE_ROUND_CAKE ||
        capsuleVm.fixedShowType === CapsuleShowType.TOP ||
        capsuleVm.fixedShowType === CapsuleShowType.RETRACTABLE_ROUND_CAKE) {
        return true;
      }
    }
    return false;
  }
}