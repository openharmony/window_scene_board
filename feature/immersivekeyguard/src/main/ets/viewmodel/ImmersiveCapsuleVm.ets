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
import { CommonUtils, ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { EventManager, EvtBus } from '@ohos/frameworkwrapper';
import { CapStyleBuilder, ImmersiveCapsuleStyle } from '../model/data/ImmersiveCapsuleStyle'
import { ImmersiveCapsuleList } from './viewdata/ImmersiveCapsuleList';
import { ImmersiveNtfData } from './viewdata/ImmersiveNtfData';
import { CapsulePositionType, ImmersiveConstants } from '../common/ImmersiveConstants';
import { ImmersiveCapsuleConstants as CapConst } from '../common/constants/ImmersiveCapsuleConstants';
import { ImmersiveAnimManager } from './viewanim/ImmersiveAnimManager';
import { KeyguardSlGreetModel } from '@ohos/screenlockcommon/src/main/ets/bean/KeyGuardStatusEnum';
import {
  immersiveKgMgr,
  ImmersiveType,
  LiveOtherExtendData,
  SysTypeCode,
  AccessibilityUtil
} from '@ohos/systemuicommon';
import { IImmersiveState, ImmersiveWidthState, immersiveStateMgr } from '../common/manager/ImmersiveStateManager';
import {
  CommonConstants as SLC,
  KeyguardStatusService,
  ScreenLockApi
} from '@ohos/screenlockcommon';
import { ImmersiveDataGroupPacker } from './viewdata/ImmersiveDataGroupProcessor';
import { FingerExtendScene, immersiveFgCtrl } from '../model/service/ImmersiveFingerControll';
import { ImmersiveAnimScene, ImmersiveNtfScene } from '../common/anim/ImmersiveAnimConstants';
import { ImmersiveCapsuleAnimManager } from './viewanim/ImmersiveCapsuleAnimManager';
import { ImmersiveExtendStyle } from '../model/data/ImmersiveExtendStyle';
import { ImmersiveCapsuleSceneHelper } from './viewdata/ImmersiveCapsuleSceneHelper';
import { NotificationStateManager, slWallpaperMgr } from '@ohos/screenlockcommon';
import { NotificationType } from '@ohos/notificationcomponent/src/main/ets/common/NotificationType';
import { ImmersiveSysEventUtil, StatusParams, ToggleWay } from '../common/ImmersiveSysEventUtil';
import { immersiveNtfSceneHelper } from './viewdata/ImmersiveNtfSceneHelper';
import { osAccount } from '@kit.BasicServicesKit';
import { ComponentPosition, WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { interruptHelper } from '../common/helper/ImmersiveInterruptHelper';
import { AnimationController } from '@ohos/mediacontrolcomponent/src/main/ets/default/Controller/AnimationController';
import {
  ScreenLockWallpaperChangeEvent
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/event/ImmersiveEvent';
import { ISlState } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { immersiveStateHelper } from '../common/helper/ImmersiveStateHelper';
import { cardList } from './viewdata/ImmersiveCardList';
import { ClockStaticStateType, SlBindStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { FingerHideScene } from '../model/service/ImmersiveFingerControll';
import { SlCapWidgetBindState } from '../model/data/SlCapWidgetBindState';

const TAG = 'ImmersiveCapsuleVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 动效场景需显示的动效胶囊位置
 */
const ANIM_SCENE_ANIM_POS: Map<ImmersiveAnimScene, CapsulePositionType[]> = new Map([
  [ImmersiveAnimScene.SCENE_CAPSULE_ROOT_HIDE,
    [CapsulePositionType.TYPE_ANIM_CONTENT, CapsulePositionType.TYPE_ANIM_SHADOW]],
  [ImmersiveAnimScene.SCENE_CAPSULE_STACK_REMOVE, [CapsulePositionType.TYPE_ANIM_CONTENT]],
  [ImmersiveAnimScene.SCENE_CAPSULE_SHADOW_REMOVE, [CapsulePositionType.TYPE_ANIM_SHADOW]]
]);

/**
 * 沉浸胶囊业务管控
 */
export class ImmersiveCapsuleVm {
  /**
   * 检查数据
   */
  public checkAndUpdateUiData: (isDisableAnim?: boolean) => void = (isDisableAnim?: boolean) => {
    if (this.isInterceptCapsuleDataUpdate(isDisableAnim)) {
      log.showWarn(`capsule is animating: ${this.capsuleAnimMgr.getRootAnimState().getSceneValues()}`);
      return;
    }
    this.capsuleAnimMgr.setDataUpdateStatus(false);
    this.checkCapsuleData();
    // 统一刷新数据
    this.oldList.update(this.showList);
    this.showList.update(this.tmpList);
    this.tmpList.clear();
    this.checkCapsuleAnim(isDisableAnim);
  }
  /**
   * 沉浸锁屏分组通知数据集
   */
  private groupManager?: ImmersiveDataGroupPacker;

  /**
   * 胶囊可显示数据列表
   */
  private showList: ImmersiveCapsuleList = new ImmersiveCapsuleList();

  /**
   * 胶囊临时数据列表
   */
  private tmpList: ImmersiveCapsuleList = new ImmersiveCapsuleList();

  /**
   * 胶囊上次显示数据列表
   */
  private oldList: ImmersiveCapsuleList = new ImmersiveCapsuleList();

  /**
   * 胶囊UI样式
   */
  private rootUiStyle: ImmersiveCapsuleStyle = CapStyleBuilder.builder()
    .bindWidth(CapConst.CAPSULE_WIDTH)
    .bindClick(() => {
      // 点击事件处理
      this.onCapsuleClick();
    })
    .build();

  /**
   * 胶囊子类型UI样式
   */
  private childrenStyle: Map<CapsulePositionType, ImmersiveCapsuleStyle> = new Map([
    // 内容胶囊样式
    [
      CapsulePositionType.TYPE_CONTENT,
      CapStyleBuilder.builder()
        .bindWidth('100%')
        .bindHeight(CapConst.CAPSULE_HEIGHT)
        .bindRootHeight(CapConst.CAPSULE_HEIGHT)
        .bindEffectColor(CapConst.CAPSULE_CAPSULE_EFFECT_COLOR)
        .bindIconClick(() => {
          // 图标点击事件处理
          let cardData = this.showList.getNtfData(CapsulePositionType.TYPE_CONTENT);
          ImmersiveSysEventUtil.reportToggleStatusEvent(cardData, StatusParams.CAPSULE, StatusParams.IMMERSIVE,
            ToggleWay.CLICK);
          ImmersiveSysEventUtil.reportEnterCpuMemEvent();
          this.onCapsuleToCard(this.showList.getNtfData(CapsulePositionType.TYPE_CONTENT));
        })
        .build()
    ],
    // 阴影胶囊样式
    [
      CapsulePositionType.TYPE_SHADOW,
      CapStyleBuilder.builder()
        .bindWidth('96%')
        .bindHeight(CapConst.CAPSULE_HEIGHT)
        .bindRootHeight(CapConst.CAPSULE_HEIGHT + CapConst.STACKED_DISTANCE)
        .bindMargin({
          top: CapConst.STACKED_DISTANCE,
          left: CapConst.STACKED_DISTANCE,
          right: CapConst.STACKED_DISTANCE
        })
        .bindAlpha(CapConst.CAPSULE_STACK_ALPHA)
        .bindEffectColor(CapConst.CAPSULE_CAPSULE_EFFECT_COLOR)
        .build()
    ],
    // 动效内容胶囊样式
    [
      CapsulePositionType.TYPE_ANIM_CONTENT,
      CapStyleBuilder.builder()
        .bindWidth('100%')
        .bindHeight(CapConst.CAPSULE_HEIGHT)
        .bindEffectColor(CapConst.CAPSULE_CAPSULE_EFFECT_COLOR)
        .build()
    ],
    // 动效阴影胶囊样式
    [
      CapsulePositionType.TYPE_ANIM_SHADOW,
      CapStyleBuilder.builder()
        .bindWidth('96%')
        .bindHeight(CapConst.CAPSULE_HEIGHT)
        .bindRootHeight(CapConst.CAPSULE_HEIGHT + CapConst.STACKED_DISTANCE)
        .bindMargin({
          top: CapConst.STACKED_DISTANCE,
          left: CapConst.STACKED_DISTANCE,
          right: CapConst.STACKED_DISTANCE
        })
        .bindAlpha(CapConst.CAPSULE_STACK_ALPHA)
        .bindEffectColor(CapConst.CAPSULE_CAPSULE_EFFECT_COLOR)
        .build()
    ],
    // 强提醒胶囊样式
    [
      CapsulePositionType.TYPE_REMIND,
      CapStyleBuilder.builder()
        .bindWidth('100%')
        .bindHeight(CapConst.CAPSULE_HEIGHT)
        .bindRootHeight(CapConst.CAPSULE_HEIGHT)
        .bindEffectColor(CapConst.CAPSULE_CAPSULE_EFFECT_COLOR)
        .build()
    ]
  ]);

  /**
   * 辅助区样式处理
   */
  private extendStyle: ImmersiveExtendStyle = new ImmersiveExtendStyle();

  /**
   * 沉浸锁屏动效管理
   */
  private animMgr?: ImmersiveAnimManager;

  /**
   * 胶囊动效管理
   */
  private capsuleAnimMgr: ImmersiveCapsuleAnimManager;

  /**
   * 胶囊数据切换回调
   */
  private onCpaDataChange = (type: CapsulePositionType, data?: ImmersiveNtfData): void => {
    // 刷新动效关联标示
    this.animMgr?.bindCapsuleAnimKey(type, data?.groupKey);
  };

  /**
   * 沉浸状态切换监听
   */
  private onImmersiveStateChange = (state?: IImmersiveState): void => {
    switch (state?.getImmersiveStateType()) {
      case ImmersiveType.TYPE_LIST:
      case ImmersiveType.TYPE_IMMERSIVE:
      case ImmersiveType.TYPE_CAPSULE:
        this.clearRemindState();
        this.checkAndUpdateUiData(true);
        break;
      case ImmersiveType.TYPE_WIDTH_DISPLAY_STATE:
        this.updateCapsuleWidth();
        break;
      default:
        break;
    }
  };

  private onExtendClick = (data?: LiveOtherExtendData, clickCount?: number): void => {
    if (!immersiveKgMgr.getImmersiveDisplayState().isShowCapsule()) {
      log.warn('onExtendClick current is not capsule scene');
      return;
    }
    if (this.capsuleAnimMgr.getRootAnimState().isSceneAnimating(ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE)) {
      log.warn('onExtendClick CapsuleRoot is animating');
      return;
    }
    data?.clickAction?.handleExtendClick(data, clickCount, NotificationType.TYPE_PHONE_KEYGUARD);
  }

  /**
   * 是否是销毁状态
   */
  private isDestroy: boolean = true;

  /**
   * 场景检测辅助类
   */
  private sceneHelper?: ImmersiveCapsuleSceneHelper;

  /**
   * 多事件统一管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 将动效胶囊的数据设置成上次显示的数据或重置操作函数
   */
  private setAnimDataFun = (isRestore: boolean, ...animTypes: CapsulePositionType[]): void => {
    animTypes.forEach((animType) => {
      if (isRestore) {
        this.showList?.setCapsuleData(animType, undefined);
        return;
      }
      let oldData: ImmersiveNtfData | undefined = undefined;
      if (animType === CapsulePositionType.TYPE_ANIM_CONTENT) {
        oldData = this.oldList?.getNtfData(CapsulePositionType.TYPE_CONTENT);
      } else if (animType === CapsulePositionType.TYPE_ANIM_SHADOW) {
        oldData = this.oldList?.getNtfData(CapsulePositionType.TYPE_SHADOW);
      }
      this.showList?.setCapsuleData(animType, oldData);
    });
  };

  /**
   * 强提醒延时任务id
   */
  private remindTaskId: number = -1;
  /**
   * 壁纸切换需要检查锁屏胶囊是否提亮压暗
   */
  private onScreenLockWallpaperChangeEvent = (event?: ScreenLockWallpaperChangeEvent): void => {
    let slClockStaticCtrl: ISlState | undefined = immersiveStateHelper.getSlClockBindState();
    if (!slClockStaticCtrl) {
      return;
    }
    let bright: number = slClockStaticCtrl.getSlState(ClockStaticStateType.BRIGHTNESS) as number;
    let slBindStatus: ISlState | undefined = immersiveStateHelper.getSlBindState();
    let isWallPaperUsing = slBindStatus?.getSlState(SlBindStateType.IS_USING_IMMERSIVE_WALL_PAPER) as boolean;

    if (isWallPaperUsing || CommonUtils.isInvalid(bright) || bright < 0) {
      this.rootUiStyle.isDarken = slWallpaperMgr.getSlWallpaperState().isLightWallpaper ?? false;
    } else {
      this.rootUiStyle.isDarken = (bright! < SLC.BRIGHT_NESS_DEFAULT);
    }
    // 缓存胶囊压暗状态
    this.getCapBindSt()?.setCapDarkMode(this.rootUiStyle.isDarken);
  }

  /* 构造
  *
  * @param animMgr 动效管理器
  * @param groupManager 分组数据管理器
  */
  constructor(animMgr: ImmersiveAnimManager, groupManager: ImmersiveDataGroupPacker) {
    this.animMgr = animMgr;
    this.capsuleAnimMgr = animMgr.getCapsuleAnimMgr();
    this.capsuleAnimMgr.setImmersiveCapsuleList(this.showList);
    this.capsuleAnimMgr.setUpdateCapsuleUiData(this.checkAndUpdateUiData);
    this.groupManager = groupManager;
    this.sceneHelper = new ImmersiveCapsuleSceneHelper(this.oldList, this.showList, groupManager);
    // 注册胶囊数据刷新监听
    this.showList.addDataChangeListener(this.onCpaDataChange);
    // 监听沉浸状态切换
    immersiveStateMgr.registerOnImmersiveStateChangeListener(this.onImmersiveStateChange);
    this.updateCapsuleWidth();
    this.extendStyle.onExtentClick = this.onExtendClick;
    this.eventMgr.on(ScreenLockWallpaperChangeEvent, this.onScreenLockWallpaperChangeEvent);
  }

  /**
   * 获取胶囊固定UI样式
   *
   * @returns 固定UI样式
   */
  getRootUiStyle(): ImmersiveCapsuleStyle {
    return this.rootUiStyle;
  }

  /**
   * 获取胶囊对应类型UI样式
   *
   * @param type 胶囊类型
   * @returns UI样式
   */
  getChildUiStyle(type: CapsulePositionType): ImmersiveCapsuleStyle | undefined {
    return this.childrenStyle.get(type);
  }

  /**
   * 获取胶囊辅助区UI样式
   *
   * @returns UI样式
   */
  getExtendUiStyle(): ImmersiveExtendStyle {
    return this.extendStyle;
  }

  /**
   * 获取可显示数据列表
   *
   * @returns 可显示数据列表
   */
  getShowList(): ImmersiveCapsuleList {
    return this.showList;
  }

  /**
   * 胶囊点击事件
   */
  onCapsuleClick() {
    let groupList = this.groupManager?.getGroupList();
    if (ArrayUtils.isEmpty(groupList)) {
      log.showWarn('capsule click has not data');
      return;
    }
    let ntfData = this.showList.getNtfData(CapsulePositionType.TYPE_CONTENT);
    let remindData = this.showList.getNtfData(CapsulePositionType.TYPE_REMIND);
    let shadowData = this.showList.getNtfData(CapsulePositionType.TYPE_SHADOW);
    let isRemindCapsule = false;
    // 如果存在强提醒胶囊，并且处于堆叠胶囊顶部时，优先处理强提醒胶囊
    if (!CommonUtils.isInvalid(remindData) && !CommonUtils.isInvalid(shadowData) &&
      ntfData?.hashCode === shadowData?.hashCode) {
      ntfData = remindData;
      isRemindCapsule = true;
    }
    log.showWarn(`getClickCapsule hashCode=${ntfData?.hashCode},isRemindCapsule=${isRemindCapsule}`);
    if (!ntfData) {
      log.showWarn('click ntfData is null');
      return;
    }
    // 如果当前点击的是强提醒胶囊，需要取消强提醒延时任务
    if (isRemindCapsule) {
      log.showWarn('handle remind capsule clear task');
      this.clearRemindTask();
    }
    if (ntfData.shouldShowInImmersiveCard()) {
      log.showWarn(`shouldShowInImmersiveCard ${ntfData.hashCode}`);
      ImmersiveSysEventUtil.reportToggleStatusEvent(ntfData, StatusParams.CAPSULE, StatusParams.IMMERSIVE,
        ToggleWay.CLICK);
      ImmersiveSysEventUtil.reportEnterCpuMemEvent();
      KeyguardStatusService.setSlGreetMode(KeyguardSlGreetModel.SL_GREET_OFF);
      this.onCapsuleToCard(ntfData);
      return;
    }
    if (this.capsuleAnimMgr.getRootAnimState().isSceneAnimating(ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE)) {
      log.showInfo('onCapsuleClick CapsuleRoot Scene SCENE_CARD_TO_CAPSULE');
      return;
    }
    ImmersiveSysEventUtil.reportToggleStatusEvent(ntfData, StatusParams.CAPSULE, StatusParams.LIST,
      ToggleWay.CLICK);
    KeyguardStatusService.setSlGreetMode(KeyguardSlGreetModel.SL_GREET_OFF);
    this.onCapsuleToList(0, ntfData);
  }

  /**
   * 胶囊过渡到列表态
   *
   * @param vel 速度
   */
  async onCapsuleToList(vel: number = 0, immersiveData?: ImmersiveNtfData): Promise<void> {
    await interruptHelper.animCap2ListIt.awaitInterrupt(); // 胶囊状态切换拦截等待
    this.startCapsuleToList(vel, immersiveData);
  }

  /**
   * 开始胶囊过渡到列表态动效
   *
   * @param vel 速度 immersiveData 通知数据
   */
  startCapsuleToList(vel: number = 0, immersiveData?: ImmersiveNtfData): void {
    this.capsuleAnimMgr.interruptCapsuleAnim();
    // 时钟元素动效需要速度共享
    NotificationStateManager.updateTouchVelocityY(vel);
    // 跟手场景，关闭动效时延效果
    NotificationStateManager.updateDisableDelay(vel !== 0);
    // 当前沉浸态，则卡片过渡列表
    if (immersiveKgMgr.getImmersiveDisplayState().isImmersive()) {
      this.animMgr?.startCardToListFixAnim(vel);
    }
    // 当前胶囊态，则胶囊过渡列表
    if (immersiveKgMgr.getImmersiveDisplayState().isCapsule()) {
      immersiveFgCtrl.addFingerHideScene(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX);
      immersiveStateMgr.switchImmersiveState(ImmersiveType.TYPE_LIST);
      this.startCapsule2ListAnim(vel, immersiveData);
    }
  }

  /**
   * 设置销毁状态
   *
   * @param isDestroy 是否销毁
   */
  setDestroy(isDestroy: boolean): void {
    log.showWarn(`isDestroy:${isDestroy}`);
    this.capsuleAnimMgr.interruptCapsuleAnim();
    this.isDestroy = isDestroy;
  }

  /**
   * 在开始胶囊态到沉浸态前进行类型和状态校验
   *
   * @param immersiveData 卡片数据
   */
  checkBeforeToCard(immersiveData?: ImmersiveNtfData): void {
    // 判断是否是UiExtension类型卡片
    if (!immersiveData?.isUiExtensionCard() || immersiveStateMgr.getUnlockedState()) {
      this.startCapsuleToCard(immersiveData);
      return;
    }
    // 如果是Uiextension类型卡片判断开机后应用是否进行了第一次解锁
    let accountManager: osAccount.AccountManager = osAccount.getAccountManager();
    try {
      accountManager.isOsAccountUnlocked().then((isVerified: boolean) => {
        if (isVerified) {
          immersiveStateMgr.setUnlockedState();
          this.startCapsuleToCard(immersiveData);
          return;
        }
        ScreenLockApi.requestUnlock();
      });
    } catch (err) {
      log.error('isOsAccountUnlocked exception');
    }
  }

  /**
   * 拦截动效期间的胶囊数据刷新
   *
   * @param isDisableAnim 是否启用数据动效 undefined时为数据驱动
   * @returns 如果拦截数据不刷新直接返回true  如果拦截数据不刷新并在动效结束后刷新标志后在返回true
   */
  private isInterceptCapsuleDataUpdate(isDisableAnim?: boolean): boolean {
    let rootAnimState = this.capsuleAnimMgr.getRootAnimState();
    // 在连续数据,胶囊到列表动效被打断的时候,会短暂把阴影胶囊数据刷新出来导致异常
    if (isDisableAnim && this.checkCapsuleInterruption(rootAnimState)) {
      return true;
    }
    if (isDisableAnim && immersiveKgMgr.getImmersiveDisplayState().isList()) {
      this.capsuleAnimMgr.setDataUpdateStatus(true);
      return true;
    }
    if (rootAnimState.isSceneAnimating() && !isDisableAnim &&
      !rootAnimState.isSceneAnimating(ImmersiveConstants.IMMERSIVE_ONE_MIRROR_SCENE)) {
      this.capsuleAnimMgr.setDataUpdateStatus(true);
      return true;
    }
    return false;
  }

  /**
   * 针对胶囊到列表打断到胶囊的场景禁止直接刷新数据
   */
  private checkCapsuleInterruption(rootAnimState: WidgetAnimState): boolean {
    return rootAnimState.isSceneAnimating(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX) &&
      immersiveKgMgr.getImmersiveDisplayState().isCapsule();
  }

  /**
   * 计算并刷新胶囊宽度
   */
  private updateCapsuleWidth(): void {
    let capsuleWidthState = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_WIDTH_DISPLAY_STATE) as
    ImmersiveWidthState;
    this.rootUiStyle.rootWidth = capsuleWidthState.capsuleWidth;
    this.capsuleAnimMgr.updateChildViewPosition(CapsulePositionType.TYPE_CONTENT, this.rootUiStyle.rootWidth);
    this.childrenStyle.get(CapsulePositionType.TYPE_SHADOW)!.width = this.rootUiStyle.rootWidth -
      CapConst.STACKED_DISTANCE * 2;
    this.childrenStyle.get(CapsulePositionType.TYPE_ANIM_SHADOW)!.width = this.rootUiStyle.rootWidth -
      CapConst.STACKED_DISTANCE * 2;
    this.childrenStyle.forEach(style => {
      style.btnCount = capsuleWidthState.capsuleBtnCount;
    })
  }

  /**
   * 计算胶囊数据
   */
  private checkCapsuleData(): void {
    this.tmpList.clear();
    let groupList = this.groupManager?.getGroupList();
    if (!groupList || groupList.length === 0) {
      this.clearRemindState();
      immersiveFgCtrl.removeFingerHideScene();
      immersiveFgCtrl.removeFingerHideScene(FingerExtendScene.GREET_SCENE);
      return;
    }

    let remindData = this.showList.getNtfData(CapsulePositionType.TYPE_REMIND);
    for (let i = 0; i < groupList.length; i++) {
      let group = groupList[i];

      if (this.isFilterOutData(group)) {
        continue;
      }

      // 填充最上层所需显示的胶囊数据
      if (!this.tmpList.getNtfData(CapsulePositionType.TYPE_CONTENT)) {
        this.tmpList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, group);
        continue;
      }

      // 填充阴影胶囊数据
      if (!this.tmpList.getNtfData(CapsulePositionType.TYPE_SHADOW)) {
        this.tmpList.setCapsuleData(CapsulePositionType.TYPE_SHADOW, group);
        if (CommonUtils.isInvalid(remindData)) {
          break;
        }
      }
      if (remindData?.groupKey === group.groupKey) {
        remindData = group;
        break;
      }
    }
    if (KeyguardStatusService.isSlGreetMode() && this.tmpList.getNtfData(CapsulePositionType.TYPE_CONTENT)) {
      immersiveFgCtrl.addFingerHideScene(FingerExtendScene.GREET_SCENE);
    } else if (immersiveFgCtrl.isLowPosFingerPrint() && this.tmpList.getNtfData(CapsulePositionType.TYPE_CONTENT) &&
    immersiveKgMgr.getImmersiveDisplayState().isCapsule()) {
      immersiveFgCtrl.addFingerHideScene();
    }
    if (remindData) {
      this.tmpList.setCapsuleData(CapsulePositionType.TYPE_REMIND, remindData);
    }
  }

  /**
   * 过滤不在胶囊显示的数据
   *
   * @param data 沉浸通知数据
   * @returns 是否被过滤
   */
  private isFilterOutData(data: ImmersiveNtfData): boolean {
    if (!immersiveKgMgr.getImmersiveDisplayState().isImmersive() && data.isShownInCard()) {
      return false;
    }
    return data.isShownInCard();
  }

  /**
   * 开启胶囊过渡列表动效
   *
   * @param vel速度
   */
  private startCapsule2ListAnim(vel: number, immersiveData?: ImmersiveNtfData): void {
    // 动效期间屏蔽指纹显示
    let scene = ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX;
    let size: number = this.groupManager?.getGroupList()?.length ?? 0;
    if (size === 0) {
      this.resumeState(scene);
      return;
    }
    this.animMgr?.startCapsule2ListFixAnim(vel, undefined, () => {
      this.resumeState(scene);
    });
    // 胶囊态切换到列表态，无障碍播报'已展开'，并且自动聚焦到对应的通知卡片
    AccessibilityUtil.sendAccessibilityByResource($r('app.string.cc_accessibility_str_ntf_swipe_left_text'));
    let ntfData = this.showList.getNtfData(CapsulePositionType.TYPE_CONTENT);
    let capData = CommonUtils.isInvalid(immersiveData) ? ntfData : immersiveData;
    let groupKey: string = capData?.groupKey ?? '';
    let hashCode: string = capData?.hashCode ?? '';
    let childrenCount: number = capData?.capsuleData?.childrenCount ?? 0;
    let targetId: string = ImmersiveConstants.getImmersiveID(groupKey);
    if (childrenCount > 1 && !CommonUtils.isInvalid(groupKey)) {
      targetId = 'NotificationGroupItem_GroupBrief_' + groupKey;
    }
    if (childrenCount === 1 && !CommonUtils.isInvalid(hashCode)) {
      targetId = 'NotificationSingleItem_Single_' + hashCode;
    }
    AccessibilityUtil.requestFocusAccessibility(targetId);
  }

  /**
   * 胶囊过渡列表动效结束状态复原
   *
   * @param scene 动效场景
   */
  private resumeState(scene?: FingerHideScene): void {
    immersiveFgCtrl.removeFingerHideScene(scene);
    NotificationStateManager.updateTouchVelocityY(0);
    NotificationStateManager.updateDisableDelay();
  }

  /**
   * 开始胶囊态到沉浸态
   *
   * @param immersiveData 卡片数据
   */
  private startCapsuleToCard(immersiveData?: ImmersiveNtfData): void {
    this.showList?.setCapsuleData(CapsulePositionType.TYPE_ANIM_CONTENT,
      this.showList.getNtfData(CapsulePositionType.TYPE_CONTENT));
    let tmpPostion = this.capsuleAnimMgr?.getCapValidPos(CapsulePositionType.TYPE_CONTENT);
    let oldCapsulePosition: ComponentPosition = {
      globalX: tmpPostion?.globalX,
      globalY: tmpPostion?.globalY,
      width: tmpPostion?.width,
      height: tmpPostion?.height,
    };
    immersiveStateMgr.requestImmersiveCard(immersiveData, true);
    let isStatusChange = false;
    if (!immersiveKgMgr.getImmersiveDisplayState().isImmersive()) {
      isStatusChange = true;
      if (immersiveData?.cardData?.liveView?.sysTypeCode === SysTypeCode.BROADCASTING_CENTER) {
        // 大卡提前上树
        cardList.setShowData(immersiveData);
        AnimationController.startCapsuleToCardAnim();
      }
      immersiveStateMgr.switchImmersiveState(ImmersiveType.TYPE_IMMERSIVE);
    }
    this.animMgr?.startCapsuleToCardAnim(() => {
      this.showList?.setCapsuleData(CapsulePositionType.TYPE_ANIM_CONTENT, undefined);
    }, oldCapsulePosition, !isStatusChange);
    if (!isStatusChange) {
      this.animMgr?.startCardToCapsuleAnim(true);
    }
    // 胶囊态切换到沉浸态，无障碍播报'已展开'，并且自动聚焦沉浸态卡片
    AccessibilityUtil.sendAccessibilityByResource($r('app.string.cc_accessibility_str_ntf_swipe_left_text'));
    AccessibilityUtil.requestFocusAccessibility(ImmersiveConstants.IMMERSIVE_CARD_ITEM_ID);
  }

  /**
   * 胶囊过渡到卡片态
   *
   * @param immersiveData 卡片数据
   */
  private onCapsuleToCard(immersiveData?: ImmersiveNtfData): void {
    if (this.capsuleAnimMgr.getRootAnimState().isSceneAnimating(ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE) &&
    immersiveKgMgr.getImmersiveDisplayState().isCapsule()) {
      log.showInfo('onCapsuleToCard CapsuleRoot is animating');
      return;
    }
    let capsuleState = this.animMgr?.getCapsuleAnimState(CapsulePositionType.TYPE_CONTENT);
    if (this.shouldNotResponse(capsuleState)) {
      log.showInfo(`onCapsuleToCard, is animating in capsule to card`);
      return;
    }

    // 数据是否为有效卡片
    let canCard = immersiveData?.shouldShowInImmersiveCard() ?? false;
    if (!canCard) {
      log.showWarn(`canCard isInvalid ${immersiveData?.hashCode}`);
      return;
    }

    this.checkBeforeToCard(immersiveData);
  }

  private shouldNotResponse(state: WidgetAnimState | undefined): boolean | undefined {
    return state?.isSceneAnimating(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX) ||
    state?.isSceneAnimating(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH) ||
    state?.isSceneAnimating(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH_BACK);
  }

  /**
   * 根据通知数据检查是否启动胶囊动效
   *
   * @param isDisableAnim 不使能动效
   */
  private checkCapsuleAnim(isDisableAnim?: boolean): void {
    // 已经存在强提醒不继续执行动效
    if (this.remindTaskId !== -1) {
      this.clearRemindState();
      return;
    }
    if (!this.isEndableCapsuleAnim(isDisableAnim)) {
      return;
    }
    let groupList = this.groupManager?.getGroupList();
    if (CommonUtils.containerIsEmpty(groupList)) {
      return;
    }
    if (!immersiveKgMgr.getImmersiveDisplayState().isShowCapsule()) {
      log.showWarn('Non-Capsule Show Status');
      return;
    }
    let animScene = this.sceneHelper?.checkAnimScene() as ImmersiveAnimScene;
    if (CommonUtils.isInvalid(animScene)) {
      return;
    }
    if (animScene === ImmersiveAnimScene.SCENE_CAPSULE_REMIND) {
      this.processCapsuleRemind();
      return;
    }
    let animPosition = ANIM_SCENE_ANIM_POS.get(animScene) ?? [];
    if (animPosition.length > 0) {
      let onStart = () => this.setAnimDataFun(false, ...animPosition);
      let onEnd = () => this.setAnimDataFun(true, ...animPosition);
      this.capsuleAnimMgr?.startAnim(animScene, onStart, onEnd);
    } else {
      this.capsuleAnimMgr?.startAnim(animScene);
    }
  }

  /**
   * 是否开启胶囊动效
   *
   * @param isDisableAnim 不使能动效
   * @returns 是否开启胶囊动效
   */
  private isEndableCapsuleAnim(isDisableAnim?: boolean): boolean {
    if (!CapConst.CAPSULE_ANIM_ENABLE || this.isDestroy || isDisableAnim) {
      // 设置来新通知自动亮屏后做强提醒动效
      if (AppStorage.get('isNotificationWakeUp')) {
        return true;
      }
      return false;
    }
    if (immersiveKgMgr.getImmersiveDisplayState().isCapsule()) {
      return true;
    }
    if (immersiveKgMgr.getImmersiveDisplayState().isImmersive()) {
      return true;
    }
    return false;
  }

  /**
   * 胶囊强提醒处理
   */
  private processCapsuleRemind() {
    let remindData = this.getRemindData();
    let contentData = this.showList.getNtfData(CapsulePositionType.TYPE_CONTENT);
    let shadowData = this.showList.getNtfData(CapsulePositionType.TYPE_SHADOW);
    if (CommonUtils.isInvalid(remindData)) {
      return;
    }
    this.clearRemindTask();
    this.showList?.setCapsuleData(CapsulePositionType.TYPE_REMIND, remindData);
    this.remindTaskId = setTimeout(() => {
      this.processSecondCapsuleRemind(shadowData);
    }, CapConst.CAPSULE_REMIND_DURATION);
    this.capsuleAnimMgr.startAnim(ImmersiveAnimScene.SCENE_CAPSULE_REMIND,
      () => this.showList?.setCapsuleData(CapsulePositionType.TYPE_SHADOW, contentData));
  }

  /**
   * 胶囊强提醒第二段动效
   */
  private processSecondCapsuleRemind(shadowData: ImmersiveNtfData) {
    if (this.capsuleAnimMgr.getRootAnimState().isSceneAnimating(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH)) {
      this.clearRemindTask();
      this.remindTaskId = setTimeout(() => {
        this.processSecondCapsuleRemind(shadowData);
      }, CapConst.CAPSULE_REMIND_DURATION);
      return;
    }
    if (!this.showList?.getNtfData(CapsulePositionType.TYPE_REMIND)) {
      this.showList?.setCapsuleData(CapsulePositionType.TYPE_SHADOW, shadowData);
      return;
    }
    if (!this.isEndableCapsuleAnim()) {
      this.showList?.setCapsuleData(CapsulePositionType.TYPE_REMIND, undefined);
      this.showList?.setCapsuleData(CapsulePositionType.TYPE_SHADOW, shadowData);
      return;
    }
    let start = () => {
      this.showList?.setCapsuleData(CapsulePositionType.TYPE_SHADOW, shadowData);
    }
    this.capsuleAnimMgr?.startAnim(ImmersiveAnimScene.SCENE_CAPSULE_REMIND_EXIT, start,
      () => this.showList?.setCapsuleData(CapsulePositionType.TYPE_REMIND, undefined));
  }

  /**
   * 获取强提醒数据
   *
   * @returns 强提醒数据
   */
  private getRemindData(): ImmersiveNtfData | undefined {
    let groupList = this.groupManager?.getGroupList();
    if (!groupList || groupList.length === 0) {
      return undefined;
    }
    for (let i = 0; i < groupList.length; i++) {
      let group = groupList[i];
      if (this.isFilterOutData(group)) {
        continue;
      }
      if (immersiveNtfSceneHelper.checkImmersiveDataScene(group.groupKey,
        ImmersiveNtfScene.SCENE_NTF_ADD, true)) {
        return i < 1 ? undefined : group;
      }
      if (immersiveNtfSceneHelper.checkImmersiveDataScene(group.groupKey,
        ImmersiveNtfScene.SCENE_NTF_UPDATE, true)) {
        if (group.capsuleData?.isCapsuleRemind()) {
          return group;
        }
      }
    }
    return undefined;
  }

  /**
   * 清除强提醒状态
   */
  private clearRemindState() {
    if (this.showList?.getNtfData(CapsulePositionType.TYPE_REMIND)) {
      this.showList?.setCapsuleData(CapsulePositionType.TYPE_REMIND, undefined);
    }
    this.clearRemindTask();
  }

  /**
   * 取消强提醒延时任务
   */
  private clearRemindTask() {
    if (this.remindTaskId !== -1) {
      clearTimeout(this.remindTaskId);
      this.remindTaskId = -1;
    }
  }

  private getCapBindSt(): SlCapWidgetBindState {
    return immersiveStateHelper.getSlCapsuleWidgetBindState() as SlCapWidgetBindState;
  }
}