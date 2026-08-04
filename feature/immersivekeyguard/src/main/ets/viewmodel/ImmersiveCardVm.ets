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
import common from '@ohos.app.ability.common';
import bundleManager from '@ohos.bundle.bundleManager';
import Want from '@ohos.app.ability.Want';
import wantAgent from '@ohos.app.ability.wantAgent';
import { CardAnimType, ImmersiveConstants } from '../common/ImmersiveConstants';
import { cardList, CardListType, ImmersiveCardList } from './viewdata/ImmersiveCardList';
import { ImmersiveNtfData } from './viewdata/ImmersiveNtfData';
import {
  BaseNotification,
  immersiveKgMgr,
  SysTypeCode,
  ImmersiveSysEventUtils,
  bannerMgr,
  SceneFlag,
  scbStatusBarStatusManager,
} from '@ohos/systemuicommon';
import { BrightnessOptionUtils, StatusBarExternalVm } from '@ohos/systemuicommon/Index';
import { LogDomain, LogHelper, CommonUtils } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import {
  IImmersiveState,
  ImmersiveCardState,
  immersiveStateMgr,
  ImmersiveWidthState,
} from '../common/manager/ImmersiveStateManager';
import {
  ImmersiveLiveAnimSceneEnum as AnimScene,
  ImmInvertColorInfo,
  ImmInvertColorMgr,
  ImmRunningLockMgr,
  OnInvertColorChangeListener,
} from '@ohos/screenlockcommon/Index';
import {
  slWallpaperMgr,
  SLWallpaperType,
  SLWallpaperVisibleScene,
  CommonConstants,
  WAnimProperty,
  ScreenLockApi,
  KeyguardStatusService,
  DisplayUtils,
  ClockStaticStateType,
} from '@ohos/screenlockcommon';
import { ImmersiveAnimManager } from './viewanim/ImmersiveAnimManager';
import { ImmersiveType, fontScaleManager, FontScaleState } from '@ohos/systemuicommon';
import { ImmersiveDataGroupPacker } from './viewdata/ImmersiveDataGroupProcessor';
import { ImmersiveCardAnimManager } from './viewanim/ImmersiveCardAnimManager';
import { ImmersiveCardData } from './viewdata/ImmersiveCardData';
import { ImmersiveCardStyle } from '../model/data/ImmersiveCardStyle';
import { ImmersiveAnimScene } from '../common/anim/ImmersiveAnimConstants';
import { LiveCustomerStyle } from '@ohos/systemuicommon/src/main/ets/liveview/info/card/LiveCustomerStyle';
import { immersiveStateHelper } from '../common/helper/ImmersiveStateHelper';
import {
  OneMirrorStaticStateType,
  SlBindStateType,
  SlMainStateType,
  SlStaticStateType,
  SlSubStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ImmersivePanelState } from './viewdata/ImmersivePanelState';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import { IBaseStateChangeListener, SlStateBaseMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { interruptHelper } from '../common/helper/ImmersiveInterruptHelper';
import { ImmersiveSysEventUtil, StatusParams } from '../common/ImmersiveSysEventUtil';
import {
  immeLiveStateShareMgr
} from '@ohos/screenlockcommon/Index';
import { SlCardWidgetBindState } from '../model/data/SlCardWidgetBindState';
import { ImmersiveCardConst } from '../common/constants/ImmersiveCardConst';

const IMAGE_DELAY: number = 200;

// 暂定退出沉浸态5分钟后清除UIExtension缓存数据
const DELAYED_CHECK_TIME: number = 5 * 60 * 1000;
const TAG = 'ImmersiveCardVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const CARD_FOLD_CLEAR_DELAY_TIME_MS: number = 400;

/**
 * 大卡更新策略枚举
 */
export enum CardUpdateStratagemEnum {
  DEFAULT,
  SMALL_SCREEN
}

/**
 * 沉浸卡片页面业务管控
 */
export class ImmersiveCardVm {
  /**
   * 沉浸锁屏分组通知数据集
   */
  private groupManager?: ImmersiveDataGroupPacker;

  /**
   * 沉浸锁屏动效管理
   */
  private immersiveAnimMgr?: ImmersiveAnimManager;

  /**
   * 卡片动效管理器
   */
  private cardAnimMgr?: ImmersiveCardAnimManager;

  /**
   * 沉浸卡片面板状态
   */
  private panelState: ImmersivePanelState = new ImmersivePanelState();

  /**
   * 沉浸卡片UI数据
   */
  private showList: ImmersiveCardList = cardList;

  /**
   * 卡片临时数据列表
   */
  private tmpList: ImmersiveCardList = new ImmersiveCardList(CardListType.TYPE_TEMP);

  /**
   * 清除UIExtension缓存计时器ID
   */
  private clearCacheTimeoutId: number | null = null;

  /**
   * 卡片样式
   */
  private cardStyle: ImmersiveCardStyle = new ImmersiveCardStyle();

  private customLiveStyle: LiveCustomerStyle = {
    cardMarginTop: $r('app.float.immersive_card_content_margin_top'),
    cardMarginBottom: $r('app.float.immersive_card_content_margin_bottom'),
    cardMarginHorizontal: $r('app.float.immersive_card_content_margin_horizontal'),
    titleFontWeight: FontWeight.Medium,
    titleFontSize: $r('sys.float.ohos_id_text_size_headline8'),
    richTextFontSize: $r('sys.float.ohos_id_text_size_body1')
  };

  private smallFoldOuterStyle: LiveCustomerStyle = {
    cardMarginTop: $r('app.float.immersive_card_content_margin_top_small_fold'),
    cardMarginBottom: $r('app.float.immersive_card_content_margin_bottom_small_fold'),
    cardMarginHorizontal: $r('app.float.immersive_card_content_margin_horizontal_small_fold'),
    titleFontWeight: FontWeight.Bold,
    titleFontSize: $r('sys.float.ohos_id_text_size_body2'),
    titleMinFontSize: $r('sys.float.ohos_id_text_size_body2'),
    richTextFontSize: $r('sys.float.ohos_id_text_size_body3'),
    bottomHalfHeight: $r('app.float.immersive_bottom_half_height_small_fold'),
    titleLineHeight: $r('app.float.immersive_title_line_height_small_fold'),
    richTextLineHeight: $r('app.float.immersive_rich_text_line_height_small_fold'),
    fixedAreaHeight: $r('app.float.immersive_fixed_area_height_small_fold'),
    titleMaxFontScale: FontScaleState.systemUIMaxScale,
  };

  /**
   * 适老化
   */
  private fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();

  /**
   * 内屏沉浸态状态
   */
  private innerImmersiveType: ImmersiveType = immersiveKgMgr.getDefaultImmersiveType();
  /**
   * 当前沉浸状态
   */
  private curImmersiveStateType?: ImmersiveType;

  /**
   * 沉浸态卡片UI绑定状态
   */
  private bindCardStateCtrl?: SlCardWidgetBindState;

  /**
   * 沉浸态实况胶囊被点击业务逻辑处理
   */
  private liveCapsuleClick: () => void = () => {
    if (SlStateBaseMgr.isV2Enable()) {
      return;
    }
    if (!immersiveKgMgr.getImmersiveDisplayState().isImmersive()) {
      this.immersiveAnimMgr?.getImmeLiveAnimMgr().interruptedExecutor(AnimScene.SCENE_LIVE_CAPSULE_IMME_CARD_TRANSFORM);
      immersiveStateMgr.switchImmersiveState(ImmersiveType.TYPE_LIST);
      bannerMgr.requestPanelLiveList();
    } else {
      // 退出沉浸态，小外屏记忆能力置为默认非沉浸态
      immersiveKgMgr.setOuterDefaultImmState(false);
      this.immersiveAnimMgr?.getImmeLiveAnimMgr().interruptedExecutor(AnimScene.SCENE_LIVE_LIST_IMME_CARD_TRANSFORM);
      this.cardAnimMgr?.fillImmersiveCardAnimData();
      let immeCode = this.showList.showData?.hashCode;
      immersiveStateMgr.switchImmersiveState(ImmersiveType.TYPE_LIST);
      bannerMgr.requestPanelLiveList(SceneFlag.SCENE_REQUEST_LIVE_LIST_BY_IMMERSIVE);
      this.immersiveAnimMgr?.startImmeCardToLiveListFixAnim(immeCode);
    }
  }

  /**
   * 沉浸状态切换监听
   */
  private onImmersiveStateChange = (state?: IImmersiveState): void => {
    // V2处理
    if (SlStateBaseMgr.isV2Enable()) {
      return;
    }
    this.curImmersiveStateType = state?.getImmersiveStateType();
    switch (state?.getImmersiveStateType()) {
      case ImmersiveType.TYPE_WIDTH_DISPLAY_STATE:
        this.updateCardStyle();
        break;
      default:
        if (this.curImmersiveStateType === ImmersiveType.TYPE_IMMERSIVE) {
          // 锁屏壁纸进入沉浸样式
          slWallpaperMgr.enterSlWallpaperScene(SLWallpaperType.TYPE_IMMERSIVE_STYLE,
            SLWallpaperVisibleScene.SCENE_IMMERSIVE_CARD);
        } else {
          // 锁屏壁纸退出沉浸样式
          if (!this.isOtherTheme()) {
            slWallpaperMgr.exitSlWallpaperScene(SLWallpaperType.TYPE_IMMERSIVE_STYLE,
              SLWallpaperVisibleScene.SCENE_IMMERSIVE_CARD);
          }
          // 退出沉浸态时，清空反色沉浸态数据
          ImmInvertColorMgr.getInstance().setCurShowingImmersive();
          // 退出沉浸态时，清空常亮沉浸态数据
          ImmRunningLockMgr.getInstance().setCurShowingImmersive();
          this.clearCardFoldFlag(CARD_FOLD_CLEAR_DELAY_TIME_MS);
        }
        this.updateTipStyle();
        this.cardStageChange();
        this.checkAndUpdateUiData(state as ImmersiveCardState);
        break;
    }
  };

  /**
   * 沉浸态状态变化
   */
  private cardStageChange(): void {
    if (immersiveKgMgr.getImmersiveDisplayState().isShowCard()) {
      if (this.clearCacheTimeoutId) {
        this.clearDelayTimeout();
      }
    } else {
      if (this.showList.getUiExtensionDataArr.length !== 0) {
        this.setDelayTimeout();
      }
    }
  }

  private setDelayTimeout(): void {
    if (this.clearCacheTimeoutId) {
      this.clearDelayTimeout();
    }
    this.clearCacheTimeoutId = setTimeout(() => {
      this.clearCacheTimeoutId = null;
      this.showList.clearUiExtensionData();
    }, DELAYED_CHECK_TIME);
  }

  private clearDelayTimeout(): void {
    if (this.clearCacheTimeoutId) {
      clearTimeout(this.clearCacheTimeoutId);
      this.clearCacheTimeoutId = null;
    }
  }

  /**
   * 锁屏状态变化监听
   */
  private slStaticStateListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === SlStaticStateType.CLOCK_NO_SIGN_SHOW_REGION) {
        this.updatePanelPaddingTop();
      }

    }
  };

  /**
   * 反色信息切换回调
   */
  private onInvertColorChange: OnInvertColorChangeListener = {
    onInvertColorChange: (curInvertColor: ImmInvertColorInfo): void => {
      this.updateInvertColor(curInvertColor);
    },
  };


  /**
   * 构造
   *
   * @param animMgr 动效管理器
   * @param groupManager 组通知管理
   */
  constructor(animMgr: ImmersiveAnimManager, groupManager: ImmersiveDataGroupPacker) {
    immeLiveStateShareMgr.setLiveCapsuleClick(this.liveCapsuleClick);
    this.groupManager = groupManager;
    this.immersiveAnimMgr = animMgr;
    this.cardAnimMgr = animMgr.getCardAnimMgr();
    this.cardAnimMgr?.setImmersiveCardData(this.showList);
    // 监听沉浸状态切换
    immersiveStateMgr.registerOnImmersiveStateChangeListener(this.onImmersiveStateChange);
    this.cardAnimMgr?.getRootAnimState()?.registerStateChangeListener?.(this.onRootStateChange);
    this.initCardStyle();
    slUiStateMgr.registerSlStateChangeListener(this.slStaticStateListener);
    this.updatePanelPaddingTop();
  }

  /**
   * 初始化
   */
  initVm(): void {
    if (SlStateBaseMgr.isV2Enable()) {
      return;
    }
    // 初始化时，未回收数据复用
    ImmInvertColorMgr.getInstance().setCurShowingImmersive(this.showList?.showData?.hashCode);
    // 注册反色回调
    ImmInvertColorMgr.getInstance().registerInvertListener(this.onInvertColorChange);
    // 沉浸态常亮管理初始化
    ImmRunningLockMgr.getInstance().init();
    this.bindCardStateCtrl = immersiveStateHelper.getImmerseCardBindState() as SlCardWidgetBindState;
    this.clearCardFoldFlag(0);
  }

  /**
   * 资源回收
   */
  destroy(): void {
    // 清除沉浸状态，注销回调
    ImmInvertColorMgr.getInstance().deleteAllCache();
    ImmInvertColorMgr.getInstance().unregisterInvertListener(this.onInvertColorChange);
    ImmRunningLockMgr.getInstance().destroy();
    this.clearCardFoldFlag(0);
    this.bindCardStateCtrl = undefined;
    this.showList.clearUiExtensionData();
  }

  /**
   * 设置更新数据
   *
   * @param oldData 旧数据
   * @param entry 新数据
   */
  public setUpdateData(oldData: ImmersiveNtfData, entry: BaseNotification): void {
    if (oldData?.groupKey ===
      this.showList.showData?.groupKey && immersiveKgMgr.getImmersiveDisplayState().isImmersive()) {
      if (!this.isNeedToAnim(oldData)) {
        // 如果拉起的是UiExtension 不要整个沉浸式卡片更新
        return;
      }
      let oriData: ImmersiveNtfData = new ImmersiveNtfData();
      let oriCardData: ImmersiveCardData = new ImmersiveCardData();
      oriData.setCardData(oriCardData);
      oriData.update(oldData);
      oriData.setLiveViewData(oldData.cardData?.cardLiveView);
      this.showList.setShowData(oriData);
      this.startCardUpdateAnim(entry);
    }
  }

  private isNeedToAnim(oldData: ImmersiveNtfData): boolean {
    if (this.showList.showData?.cardData?.immersiveWant ||
      oldData.cardData?.liveView?.sysTypeCode === SysTypeCode.BROADCASTING_CENTER ||
      immersiveKgMgr.getOneMirrorState().getAodStyle(true)?.isAod) {
      return false
    }
    return true;
  }

  private async startCardUpdateAnim(entry: BaseNotification): Promise<void> {
    await interruptHelper.cardDataChangeIt.awaitInterrupt(); // 数据刷新拦截等待
    this.cardAnimMgr?.getChildAnimState(CardAnimType.CARD_UPDATE_TYPE)?.setAlpha(0);
    let updateData: ImmersiveNtfData = new ImmersiveNtfData();
    let newCardData: ImmersiveCardData = new ImmersiveCardData();
    updateData.setCardData(newCardData);
    updateData.update(entry.immersiveNtfData);
    updateData.setLiveViewData(entry.liveViewData);

    this.showList.setAnimData();
    this.cardAnimMgr?.getChildAnimState(CardAnimType.CARD_UPDATE_TYPE)?.setAlpha(0);
    this.cardAnimMgr?.getRootAnimState()?.setAnimScene({
      isAnimating: true,
      animScene: ImmersiveAnimScene.SCENE_CARD_UPDATE
    });
    this.cardAnimMgr?.getChildAnimState(CardAnimType.CARD_UPDATE_TYPE)?.setAnimScene(
      { isAnimating: true, animScene: ImmersiveAnimScene.SCENE_CARD_UPDATE });
    setTimeout(() => {
      this.cardAnimMgr?.doUpdateCardAnim(
        () => {
          this.showList.setAnimData(updateData);
        },
        () => {
          this.showList.setShowData(updateData);
        },
        () => {
          this.showList.setAnimData();
        }, this.getUpdateStratagem());
    }, IMAGE_DELAY)
  }

  private updateInvertColor(curInvertColor: ImmInvertColorInfo): void {
    log.showInfo(`updateInvertColor: ${curInvertColor?.getSbContentColor()}, ${curInvertColor?.isSbBgGradientEnable()}`);
    // 小折叠刷新状态栏反色
    scbStatusBarStatusManager.setImmersiveStatusbarColor(curInvertColor?.getSbContentColor());
    // 状态栏背景渐变色开关
    StatusBarExternalVm.instance.setIsShowGradientBackground(curInvertColor?.isSbBgGradientEnable());
  }

  /**
   * 面板状态
   *
   * @returns 面板状态
   */
  public getPanelState(): ImmersivePanelState {
    return this.panelState;
  }

  /**
   * 获取可显示数据列表
   *
   * @returns 可显示数据列表
   */
  getShowList(): ImmersiveCardList {
    return this.showList;
  }

  /**
   * 获取卡片样式
   *
   * @returns 卡片样式
   */
  getCardStyle(): ImmersiveCardStyle {
    return this.cardStyle;
  }

  getLiveStyle(): LiveCustomerStyle {
    return this.customLiveStyle;
  }

  getSmallFoldOuterStyle(): LiveCustomerStyle {
    return this.smallFoldOuterStyle;
  }

  /**
   * 当前的沉浸态卡片是否带有壁纸（播控类）
   *
   * @returns 检测结果
   */
  hasOwnBackgroundImage(): boolean {
    return this.getShowList()?.showData?.cardData?.liveView?.sysTypeCode === SysTypeCode.BROADCASTING_CENTER;
  }

  /**
   * 检测并刷新沉浸卡片数据
   *
   * @param state 状态数据
   * @param isImmersiveDestroy 用于解锁场景数据销毁
   */
  checkAndUpdateUiData(state?: ImmersiveCardState, isImmersiveDestroy?: boolean): void {
    if (isImmersiveDestroy) {
      this.handleUiDataForDestroy();
    } else if (!state) {
      this.checkUiDataForDataChanged();
    } else {
      this.checkUiDataForStateChanged(state);
    }

    // 统一刷新数据
    if (state) {
      // 重置数据的locationErrorCode
      this.resetLocationErrorCode(this.showList.showData);
      // 统一刷新数据
      this.showList.setShowData(this.tmpList.showData);

      immersiveKgMgr.getImmersiveKeyguardState().immersiveState.isMediaCard =
        this.showList.showData?.cardData?.liveView?.sysTypeCode === SysTypeCode.BROADCASTING_CENTER;
    }
  }

  /**
   * 是否直接默认进入沉浸态
   * @returns 是否进入沉浸态
   */
  checkShouldShowImmersiveDefault(): boolean {
    if (!immersiveStateHelper.getOneMirrorStaticState()?.getSlState(OneMirrorStaticStateType.IS_DESKTOP_TO_SL)) {
      log.showInfo('not desktop to screenlock');
      return false;
    }
    // 未进行过解锁认证不允许默认进入沉浸态
    if (!immersiveStateHelper.getSlBindState()?.getSlState(SlBindStateType.OS_ACCOUNT_UNLOCK_STATE)) {
      log.showInfo('os account unlock state is not verified');
      return false;
    }
    let cardNtfData = this.groupManager?.getFirstCardData();
    if (!cardNtfData) {
      log.showInfo('not find card NtfData');
      return false;
    }
    if (KeyguardStatusService.isSlGreetMode()) {
      log.showInfo('currentMode is greetMode');
      return false;
    }
    immersiveStateMgr.requestImmersiveCard(cardNtfData);
    immersiveStateMgr.switchImmersiveState(ImmersiveType.TYPE_IMMERSIVE);
    // 默认进沉浸态打点
    ImmersiveSysEventUtil.reportShowImmCardEvent(cardNtfData);
    return true;
  }

  /**
   * 解锁跳转到应用
   * ntfData 锁屏通知数据
   */
  public clickToApp(ntfData: ImmersiveNtfData): void {
    if (!ntfData) {
      log.showInfo('is not valid ntfData');
      return;
    }
    ImmersiveSysEventUtils.reportClickToAppEvent(ntfData.cardData?.cardLiveView, StatusParams.IMMERSIVE);
    ScreenLockApi.requestUnlock({
      success: (): void => {
        log.showInfo('start click to app by card');
        this.startDoWantAgent(ntfData,
          (data: number) => {
          });
      },
    }, true);
  }

  updateCardHeight(isFoldFullDisplay: boolean, newHeight: number) {
    if ((isFoldFullDisplay || DeviceHelper.isPad()) && this.cardStyle.widescreenHeight as number > newHeight) {
      this.cardStyle.widescreenHeight = newHeight;
    }
  }

  /**
   * 获取授权提示语，应用没授权
   *
   * @param cardData 卡片数据
   */
  getNoPermissionTip(cardData: ImmersiveCardData): Resource {
    let noPermissionTip: Resource;
    switch (cardData.locationErrorCode) {
      case ImmersiveConstants.LOCATION_ERROR_CODE.NO_PERMISSION:
        noPermissionTip = $r('app.string.immersive_app_no_auth_tips');
        break;
      default:
        noPermissionTip = this.getLocationSwitchTip(cardData);
    }
    return noPermissionTip;
  }

  /**
   * 获取授权提示语行高，按设备区分档
   *
   * @param isFoldExpanded 是否展开态
   * @param font 资源值
   */
  getTipsLineHeight(font: Resource): string {
    if (DisplayUtils.isLargeScreen()) {
      return this.fontScaleState.getCardTipSize(ResUtils.getNumber(font));
    }
    if (DeviceHelper.isFullDisplayMode()) {
      return this.fontScaleState.getRecentScaleSize(font);
    }
    return this.fontScaleState.getCardSize(ResUtils.getNumber(font));
  }

  /**
   * 获取授权提示语字体最大缩放倍数，按设备区分档
   *
   * @param isFoldExpanded 是否展开态
   */
  getTipsFontScale(): number {
    if (DisplayUtils.isLargeScreen()) {
      return FontScaleState.cardTipMaxScale;
    }
    if (DeviceHelper.isFullDisplayMode()) {
      return FontScaleState.recentUIMaxScale;
    }
    return FontScaleState.cardMaxScale;
  }

  /**
   * 当前是否隐藏授权提示语的插图
   * 平板：标准档以上隐藏
   * 大折叠：1.3以上隐藏
   * 直板机：1.75及以上隐藏
   *
   * @param isFoldExpanded 是否展开态
   */
  checkIsHideTipImage(): boolean {
    if (DisplayUtils.isLargeScreen()) {
      return this.fontScaleState.fontSizeScale > FontScaleState.cardTipMaxScale;
    }
    if (DeviceHelper.isFullDisplayMode()) {
      return this.fontScaleState.fontSizeScale > FontScaleState.recentUIMaxScale;
    }
    return this.fontScaleState.fontSizeScale >= FontScaleState.cardMaxScale;
  }

  private getUpdateStratagem(): CardUpdateStratagemEnum {
    return CardUpdateStratagemEnum.DEFAULT;
  }

  private getTipBtnWidth(): Length | undefined {
    return undefined;
  }

  private getTipBgColor(): Resource | undefined {
    return undefined;
  }

  /**
   * 点击去授权
   *
   * @param cardData 卡片数据
   * @param mItemData 通知数据
   */
  onclickGoSettingBtn(cardData: ImmersiveCardData, mItemData: ImmersiveNtfData): void {
    if (cardData.locationErrorCode === ImmersiveConstants.LOCATION_ERROR_CODE.LOCATION_SWITCH_OFF) {
      this.locationAuthorization(true);
    } else if (cardData.locationErrorCode === ImmersiveConstants.LOCATION_ERROR_CODE.NO_PERMISSION) {
      this.locationAuthorization(false, mItemData?.creatorBundleName);
    }
  }

  /**
   * 位置授权
   *
   * @param uri 设置路径
   * @param boundName 应用boundName
   */
  locationAuthorization(isAuthSystem: boolean, boundName?: string): void {
    let context = getContext(this) as common.UIAbilityContext;
    let want: Want = {
      bundleName: ImmersiveConstants.SETTINGS_BUNDLE_NAME,
      abilityName: ImmersiveConstants.SETTINGS_ABILITY_NAME,
      uri: isAuthSystem ? ImmersiveConstants.LOCATION_MANAGER_URI : ImmersiveConstants.APPLICATION_ENTRY_URI,
    };
    if (!isAuthSystem) {
      want.parameters = { pushParams: boundName as string };
    }

    ScreenLockApi.requestUnlock({
      success: (): void => {
        context.startAbility(want)
          .catch((err: Error) => {
            log.showError('Failed to startAbility');
          });
      }
    });
  }

  /**
   * 访问权限认证
   *
   * @param bundleName
   * @param permission 权限编码
   * @returns boolean
   */
  hasPermission(bundleName: string, permission: string): boolean {
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_REQUESTED_PERMISSION;
    try {
      let bundleInfo = bundleManager.getBundleInfoSync(bundleName, bundleFlags, this.getCurrentUserId());
      if (!bundleInfo || !bundleInfo.reqPermissionDetails || bundleInfo.reqPermissionDetails.length === 0) {
        return false;
      }

      for (let i = 0; i < bundleInfo.reqPermissionDetails.length; i++) {
        if (bundleInfo.reqPermissionDetails[i].name === permission) {
          return bundleInfo.permissionGrantStates[i] === 0
        }
      }
    } catch (error) {
      log.showError('call hasPermission error');
    }
    return false;
  }

  /**
   * 接收UIExtension onReceive回调存储locationErrorCode
   *
   * @param cardData 卡片数据
   * @param receiveData 接收到的数据
   */
  receiveExtensionData(cardData: ImmersiveCardData, receiveData: Record<string, Object>): ImmersiveCardData {
    if (receiveData.errCode === undefined) {
      return cardData;
    }
    const locationErrorCode = Number(receiveData.errCode);
    log.showInfo(`onReceive ${locationErrorCode}`);
    if (this.hasLocationErrorCode(locationErrorCode)) {
      cardData.locationErrorCode = locationErrorCode;
    }
    return cardData;
  }

  hasLocationErrorCode(locationErrorCode: number): boolean {
    return Object.values(ImmersiveConstants.LOCATION_ERROR_CODE).includes(locationErrorCode);
  }

  /**
   * 收拢或展开卡片
   *
   * @param isFold true表示折叠，false表示展开
   */
  public changeCardState(isFold: boolean): void {
    if (!this.bindCardStateCtrl) {
      log.showError('change card state failed, bind is null.');
      return;
    }
    if (this.bindCardStateCtrl.getIsCardFold() === isFold) {
      return;
    }
    log.showInfo('change card to folds? ' + isFold);
    this.bindCardStateCtrl.setIsCardFold(isFold);
  }

  /**
   * 获取卡片是否收拢的提示图片
   *
   * @param isAod 是否aod
   * @param isCardFold 是否折叠
   * @returns
   */
  public getCardTipImg(isAod: boolean, isCardFold: boolean): Resource {
    if (isAod) {
      return $r('app.media.card_tip_down');
    }
    return isCardFold ? $r('app.media.card_tip_up') : $r('app.media.card_tip_down');
  }

  /**
   * 获取卡片align
   *
   * @param isAod 是否aod
   * @param isCardFold 是否折叠
   * @returns
   */
  public getCardAlign(isAod: boolean, isCardFold: boolean): AlignRuleOption {
    if (isAod) {
      return { bottom: { anchor: '__container__', align: VerticalAlign.Bottom } };
    }
    return isCardFold ? { top: { anchor: '__container__', align: VerticalAlign.Bottom } } :
      { bottom: { anchor: '__container__', align: VerticalAlign.Bottom } };
  }

  /**
   * 获取卡片margin
   *
   * @param isAod 是否aod
   * @param isCardFold 是否折叠
   * @returns
   */
  public getCardMargin(isAod: boolean, isCardFold: boolean): Margin {
    if (isAod) {
      return {
        bottom: ImmersiveCardConst.CARD_MARGIN_SMALL_FOLD,
        left: ImmersiveCardConst.CARD_MARGIN_SMALL_FOLD,
        right: ImmersiveCardConst.CARD_MARGIN_SMALL_FOLD
      };
    }
    return isCardFold ?
      {
        top: -ImmersiveCardConst.CARD_MARGIN_SMALL_FOLD,
        left: ImmersiveCardConst.CARD_MARGIN_SMALL_FOLD,
        right: ImmersiveCardConst.CARD_MARGIN_SMALL_FOLD
      } : {
        bottom: ImmersiveCardConst.CARD_MARGIN_SMALL_FOLD,
        left: ImmersiveCardConst.CARD_MARGIN_SMALL_FOLD,
        right: ImmersiveCardConst.CARD_MARGIN_SMALL_FOLD
      };
  }

  private clearCardFoldFlag(delay: number) {
    if (!this.bindCardStateCtrl?.getIsCardFold()) {
      return;
    }
    if (delay > 0) {
      setTimeout(() => {
        this.doClearCardFoldFlag();
      }, delay);
      return;
    }
    this.doClearCardFoldFlag();
  }

  private doClearCardFoldFlag() {
    this.bindCardStateCtrl?.setIsCardFold(false);
    log.showInfo('clear card fold flag.');
  }

  private initCardStyle(): void {
    immersiveStateMgr.updateCardWidthState();
    this.updateCardStyle();
  }

  private updateCardStyle(): void {
    let displayState: ImmersiveWidthState = immersiveStateMgr.getCurrentState(
      ImmersiveType.TYPE_WIDTH_DISPLAY_STATE) as ImmersiveWidthState;
    this.cardStyle.widescreenWidth = displayState.cardWidth;
    this.cardStyle.widescreenHeight = displayState.cardHeight;
    this.updateTipStyle();
  }

  private updateTipStyle() {
    this.cardStyle.uiExtensionTipFontScale = this.getTipsFontScale();
    this.cardStyle.uiExtensionTipLineHeight =
      this.getTipsLineHeight($r('app.float.immersive_location_font_line_height'));
    this.cardStyle.uiExtensionTipBtnLineHeight =
      this.getTipsLineHeight($r('app.float.immersive_authorize_line_height'));
    this.cardStyle.uiExtensionTipImageVisibility = !this.checkIsHideTipImage();
    this.cardStyle.uiExtensionTipBtnWidth = this.getTipBtnWidth();
    this.cardStyle.uiExtensionTipBackgroundColor = this.getTipBgColor();
  }

  /**
   * 状态刷新引起UI刷新
   */
  private checkUiDataForStateChanged(state: ImmersiveCardState): void {
    if (state?.getImmersiveStateType() !== ImmersiveType.TYPE_IMMERSIVE || !state.curImmersiveCard) {
      if (immersiveKgMgr.getImmersiveDisplayState().isCapsule() &&
      immersiveKgMgr.getBeforeImmersiveState().isImmersive()) {
        return;
      }
      if (!this.cardAnimMgr?.getRootAnimState()?.isSceneAnimating(ImmersiveAnimScene.SCENE_CARD_DELETE)) {
        this.tmpList.setShowData();
      }
      return;
    }

    if (state.isSetAnimCard) {
      this.showList.setAnimData(this.showList.showData);
      state.isSetAnimCard = false;
    }
    this.tmpList.setShowData(state.curImmersiveCard as ImmersiveNtfData);
  }

  /**
   * 通知数据刷新引起UI数据刷新
   * 非沉浸态时无需处理数据刷新任务
   * 只存在数据被删除时，退出沉浸实况
   */
  private async checkUiDataForDataChanged(): Promise<void> {
    if (!immersiveKgMgr.getImmersiveDisplayState().isImmersive()) {
      this.tmpList.setShowData();
      return;
    }
    if (this.showList.showData?.capsuleData?.isHideContent) {
      immersiveStateMgr.exitImmersiveState(false, false);
      return;
    }
    if (!this.showList.showData || this.findGroupData(this.showList.showData?.groupKey)) {
      this.tmpList.setShowData(this.showList.showData);
      return;
    }
    await interruptHelper.cardDataChangeIt.awaitInterrupt(); // 数据刷新拦截等待
    // 请求退出沉浸卡片
    if (this.isNeedAnim()) {
      this.cardAnimMgr?.doDeleteCardAnim(() => {
        // 重置数据的locationErrorCode
        this.resetLocationErrorCode(this.showList.showData);
        this.showList.setShowData();
      }, this.isOtherTheme());
      if (this.isOtherTheme()) {
        immersiveKgMgr.notifyStateChange();
      } else {
        setTimeout(() => {
          immersiveKgMgr.notifyStateChange();
        }, ImmersiveConstants.CLOCK_DELAY_TIME);
      }
      return;
    }
    this.tmpList.setShowData();
    immersiveStateMgr.exitImmersiveState(false);
  }

  private isNeedAnim(): boolean {
    return immersiveKgMgr.getBeforeImmersiveState().isCapsule() &&
      !immersiveKgMgr.getOneMirrorState().getAodStyle(true)?.isAod;
  }

  private isOtherTheme(): boolean {
    let clockSt = immersiveStateHelper.getSlClockBindState();
    return !(clockSt?.getSlState(ClockStaticStateType.CLOCK_VISIBLE_STATE) as boolean);
  }

  /**
   * 根据分组的groupKey获取分组数据
   *
   * @param groupKey 分组名
   * @returns 分组数据
   */
  private findGroupData(groupKey?: string): ImmersiveNtfData | undefined {
    let groupList = this.groupManager?.getGroupList();
    if (!groupKey || !groupList) {
      return;
    }

    for (let i = 0; i < groupList.length; i++) {
      if (groupList[i].groupKey === groupKey) {
        return groupList[i];
      }
    }
    return;
  }

  private updatePanelPaddingTop(): void { // 更新面板顶部间距
    let slStaticState = immersiveStateHelper.getSlStaticState();
    let region = slStaticState?.getSlState(SlStaticStateType.CLOCK_NO_SIGN_SHOW_REGION) as Rectangle;
    let clockHeight = region?.height as number ?? 0;
    if (clockHeight !== 0) {
      this.panelState.paddingTop = clockHeight;
    }
  }

  /**
   * 重置数据的locationErrorCode
   */
  private resetLocationErrorCode(showData: ImmersiveNtfData | undefined): void {
    if (!showData || !showData.cardData) {
      return;
    }
    showData.cardData.locationErrorCode = Infinity;
  }

  /**
   * 获取授权提示语，系统权限没开启的前提下检查应用是否授权
   *
   * @param cardData 卡片数据
   */
  private getLocationSwitchTip(cardData: ImmersiveCardData): Resource {
    const isLocationPermission = this.hasPermission(
      cardData.immersiveWant?.bundleName || '', ImmersiveConstants.APPROXIMATELY_LOCATION);
    return isLocationPermission ? $r('app.string.immersive_sys_no_auth_tips') :
    $r('app.string.immersive_app_sys_no_auth_tips')
  }

  /**
   * 获取当前用户id
   */
  private getCurrentUserId(): number {
    let currentUserId: number | undefined = AppStorage.get<number>('mCurrentUserId');
    if (currentUserId === undefined) {
      currentUserId = CommonConstants.DEFAULT_USER_ID;
    }
    return currentUserId;
  }

  private startDoWantAgent(ntfData: ImmersiveNtfData, callback: Callback<number>): void {
    try {
      wantAgent.trigger(ntfData.wantAgent, {
        code: 0,
      }, (data) => {
        if (!CommonUtils.isInvalid(callback)) {
          callback(0);
        }
      });
    } catch (error) {
      log.error('startDoWantAgent error');
    }
  }

  /**
   * 监听卡片动效状态切换
   */
  private onRootStateChange: IBaseStateChangeListener = {
    onStateChange: (stateType, stateId, property) => {
      if (property === WAnimProperty.ANIMATING) { // 动效状态切换
        log.showInfo('immersiveCard onRootStateChange');
        this.onRootStateAnimatingChange();
      }
    }
  };

  private onRootStateAnimatingChange(): void { // 动效状态切换
    let isAnimating = this.cardAnimMgr?.getRootAnimState().isSceneAnimating();
    if (isAnimating) { // 动效中时，拦截数据刷新
      interruptHelper.cardDataChangeIt.requestInterrupt();
      return;
    }
    const timeoutId = setTimeout(() => {
      // 非动效中，则放开数据刷新
      if (!this.cardAnimMgr?.getRootAnimState().isSceneAnimating()) {
        interruptHelper.cardDataChangeIt.releaseInterrupt();
        clearTimeout(timeoutId);
      }
    });
  }

  private handleUiDataForDestroy(): void {
    immersiveStateMgr.exitImmersiveState(false, false);
    this.tmpList.setShowData();
    this.showList.setAnimData();
  }
}