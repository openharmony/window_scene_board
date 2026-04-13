/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { NotificationEntry } from '../../model/NotificationEntry';
import {
  CommonUtils,
  LogDomain,
  LogHelper,
  Trace,
  ArrayUtils
} from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { baseStateMgr,
  CardScaleType,
  CardScaleUtil,
  FrameCount, ImmersiveBaseState, StateType, SystemUICommonUtil } from '@ohos/systemuicommon';
import { LiveUseScene, BannerDeformState, LiveViewData } from '@ohos/systemuicommon';
import { NtfAppIconModifier } from '../../vm/style/NtfAppIconModifier';
import { NtfCloseVM } from '../../vm/NtfCloseVM';
import { BannerFloatingController } from '../../controller/BannerFloatingController';
import { RootCard } from '@ohos/systemuicommon/Index';
import { NotificationContentInTint } from './NotificationContentInTint';
import { NotificationContent } from './NotificationContent';
import { NtfTimeVM } from '../../vm/NtfTimeVM';
import { NotificationConfig } from '../../common/NotificationConfig';
import { NtfColorModeVM } from '../../vm/NtfColorModeVM';
import { NotificationUtils } from '../../common/NotificationUtils';
import { NtfSingleItemVM } from '../../vm/NtfSingleItemVM';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';

const TAG = 'NotificationHeadsUp';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 横幅通知组件
 *
 * @since 2024-03-25
 */
@Component
export struct NotificationHeadsUp {
  /**
   * 圆角
   */
  private radius: number = NotificationConfig.BORDER_RADIUS;

  /**
   * 通知数据
   */
  @Provide ntfEntry: NotificationEntry | null = null;

  /**
   * 通知条目默认收起
   */
  @Provide isItemExpanded: boolean = false;

  /**
   * 条目内容区域
   */
  private itemContentArea?: Area;

  /**
   * close按钮VM
   */
  @Consume private closeVM?: NtfCloseVM;

  @State blurScale: number = 0;

  /**
   * 是否正在执行消失行为，连续通知场景为true
   */
  @Prop @Watch('onHidingHeadsUp') isHidingHeadsUp: boolean = false;

  persistentId: number = 0;

  @State bannerHeight: number = 0;

  /**
   * 形变相关参数
   */
  @Prop @Watch('onDeformChanged') bannerDeformState: BannerDeformState = new BannerDeformState();

  @Prop isInitParam: boolean = false;

  private bannerFloatingController: BannerFloatingController | undefined = undefined;

  /**
   * 沉浸式状态
   */
  private immersiveState: ImmersiveBaseState =
    baseStateMgr.getBaseState(StateType.TYPE_IMMERSIVE) as ImmersiveBaseState;

  @State isDropBarVisible: boolean = false;

  @State initHeight: number = 0;

  colorModeVM: NtfColorModeVM | undefined = undefined;

  /**
   * 分帧处理对象，仅需要记录到第2帧
   */
  @State frameCount: FrameCount = new FrameCount();

  /**
   * 横幅通知宽度
   */
  @Prop itemWidth: number = 0;
  /**
   * 位移
   */
  @Prop headsUpItemTranX: number = 0;
  /**
   * 前一次位移
   */
  @State preHeadsUpItemTranX: number | undefined = undefined;

  @Prop isNeedBannerInScreenLock: boolean = false;
  @Prop isShowBannerFromScreenLock: boolean = false;
  @Prop isLockScreen: boolean = false;
  /**
   * 是否删除
   */
  @Prop @Watch('onRemoveEntry') isRemoveEntry: boolean = false;
  /**
   * 是否扩展新形态小外屏
   */
  @Consume isOuterHomeFolded: boolean;
  /**
   * 条目VM
   */
  private ntfItemVM?: NtfSingleItemVM;

  /**
   * 横幅面板ID，更新中景窗状态时使用
   */
  private screenId: number = -1;

  /**
   * 当前是否是中景窗，中景窗下不允许下拉悬浮窗，不显示下拉条
   */
  private isMidScene: boolean = false;

  /**
   * 横幅通知展开状态
   */
  @State isExpand: boolean = false;
  onRemoveEntry(): void {
    if (this.isRemoveEntry) {
      this.preHeadsUpItemTranX = this.headsUpItemTranX;
    }
  }

  @State protectedVm: AppProtectedVm = AppProtectedVm.get();

  /**
   * 通知数据变化回调
   * NtfDataUpdateListener
   *
   * @param newEntry 新通知对象
   */
  onNtfDataUpdate(newEntry: NotificationEntry): void {
    this.ntfEntry = newEntry;
  }

  private onItemHoverChange(isHover: boolean): void {
    if (isHover) {
      this.closeVM?.setItemHover(this.ntfEntry!);
      this.closeVM?.updatePosition(this.ntfEntry!, this.itemContentArea!);
    } else {
      this.closeVM?.cancelItemHover(this.ntfEntry!);
    }
  }

  onFloatingCapacityChanged(isSupportFloating: boolean): void {
    log.showInfo(`onFloatingCapacityChanged, ${isSupportFloating}`);
    this.isDropBarVisible = isSupportFloating;
  }

  private onDeformChanged(): void {
    if (this.bannerDeformState.bannerMaskingOpacity === 0 && (this.bannerDeformState.bannerHeight ?? 0 > 0)) {
      this.initHeight = this.bannerDeformState.bannerHeight;
    }
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear:${this.ntfEntry?.hashCode}`);
    if (this.ntfEntry && this.screenId !== -1) {
      this.updateMidScene(this.screenId);
      this.bannerFloatingController?.updateFloatingWindowStatus(this.ntfEntry, this.isMidScene);
    }
    this.isDropBarVisible = this.bannerFloatingController?.isSupportFloating() ?? false;
    // 恢复默认展开状态
    this.isItemExpanded = this.ntfEntry?.isItemExpanded ?? false;
    // 注册通知数据变更监听
    this.ntfEntry?.registerDataUpdateListener(this);
    this.onDeformChanged();
    this.frameCount.start(2);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear:${this.ntfEntry?.hashCode}`);
    // 注销数据更新监听
    this.ntfEntry?.unregisterDataUpdateListener(this);
    this.closeVM?.cancelItemHover(this.ntfEntry!);
    this.closeVM?.setItemTranslate(0);
    if (this.persistentId != 0) {
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId)?.setFocusable(false);
    }
  }

  @Builder
  buildContent() {
    if ((this.ntfEntry as NotificationEntry).isLiveType()) { // 实况样式
      Row() {
        RootCard({
          data: (this.ntfEntry as NotificationEntry).liveViewData as LiveViewData,
          useScene: LiveUseScene.SCENE_HEADS_UP,
          isNeedBannerInScreenLock: this.isNeedBannerInScreenLock,
          isShowBannerFromScreenLock: this.isShowBannerFromScreenLock
        })
      }
      .height(this.isInitParam && this.bannerDeformState ? this.bannerDeformState.bannerHeight : undefined)
      .alignItems(VerticalAlign.Center)
    } else if (this.immersiveState?.isImmersive) {
      NotificationContentInTint({
        bannerDeformState: this.bannerDeformState,
        persistentId: this.persistentId,
        colorModeVM: this.colorModeVM,
        itemWidth: this.itemWidth,
        isDropBarVisible: this.isDropBarVisible,
        isExpand: this.isExpand,
        isNeedBannerInScreenLock: this.isNeedBannerInScreenLock,
        isShowBannerFromScreenLock: this.isShowBannerFromScreenLock,
        isLockScreen: this.isLockScreen,
        isInitParam: this.isInitParam,
        ntfItemVM: this.ntfItemVM
      })
    } else {
      NotificationContent({
        isHeadsUp: true,
        bannerDeformState: this.bannerDeformState,
        persistentId: this.persistentId,
        timeVm: new NtfTimeVM(),
        colorModeVM: this.colorModeVM,
        isDropBarVisible: this.isDropBarVisible,
        radius: {
          bottomLeft: this.radius as Length,
          bottomRight: this.radius as Length
        },
        ntfItemVM: this.ntfItemVM,
        isNeedBannerInScreenLock: this.isNeedBannerInScreenLock,
        isShowBannerFromScreenLock: this.isShowBannerFromScreenLock,
        isLockScreen: this.isLockScreen,
        isInitParam: this.isInitParam,
      })
    }
  }

  onHidingHeadsUp() {
    log.showInfo(`start hiding animator. run onHidingHeadsUp:${this.isHidingHeadsUp}, blurScale: ${this.blurScale}}`);
    if (!this.isHidingHeadsUp) {
      return;
    }

    Trace.start(`onHidingHeadsUp`);
    animateTo({
      delay: 300,
      duration: 100,
      curve: Curve.Friction,
      onFinish: () => {
        this.blurScale = 0;
        Trace.end(`onHidingHeadsUp`);
      }
    }, () => {
      this.blurScale = 0.12;
    })
  }

  @Builder
  buildContentWithDropBar() {
    Stack() {
      Column() {
        this.buildContent();
        Stack({ alignContent: Alignment.Bottom }) {
          Image($r('app.media.ic_ntf_drop'))
            .objectFit(ImageFit.Fill)
            .width($r('app.float.ntf_heads_up_drop_width'))
            .height($r('app.float.ntf_heads_up_drop_height'))
            .fillColor($r('app.color.ntf_heads_up_drop_color'))
            .align(Alignment.Center)
            .translate({
              y: this.bannerDeformState.bannerMaskingOpacity === 0 ?
                0 : ((this.bannerDeformState.bannerHeight - this.initHeight) / 2)
            })
            .margin({
              bottom: this.immersiveState?.isImmersive && !this.isExpand ?
                $r('app.float.immersive_ntf_heads_up_drop_margin_bottom') :
                $r('app.float.ntf_heads_up_drop_margin_bottom')
            })
        }.height(0)
      }
      .width(this.isInitParam ? this.bannerDeformState.bannerWidth : undefined)
      .height(this.isInitParam ? this.bannerDeformState.bannerHeight : undefined)
      .alignItems(HorizontalAlign.Center)
      .opacity(this.bannerDeformState.bannerToFloating ? 0 : 1)

      // 蒙层
      if (this.bannerDeformState.bannerMaskingVisibility) {
        Stack({ alignContent: Alignment.Center }) {
          this.buildAppIcon();
        }
        .backgroundColor($r('app.color.banner_to_floating_mask_color'))
        .width(this.isInitParam ? '100%' : 0)
        .height(this.isInitParam ? '100%' : 0)
        .opacity(this.bannerDeformState.bannerMaskingOpacity)
      }
    }
    .alignContent(Alignment.Start)
  }

  @Builder
  buildAppIcon() {
    // 复制的图标
    Image(this.ntfEntry?.getAppIcon(true))
      .id(this.ntfEntry?.hashCode + '_HeadsUpAppIcon')
      .attributeModifier(new NtfAppIconModifier(
        this.immersiveState?.isImmersive && !this.isExpand ? $r('app.float.ntf_small_icon_size_in_tint') :
          $r('app.float.ntf_small_icon_size_phone'),
        this.immersiveState?.isImmersive && !this.isExpand ? $r('app.float.ntf_action_button_radius') :
          $r('app.float.ntf_item_right_icon_radius'), undefined, false))
      .scale({
        x: this.bannerDeformState.bannerIconScale,
        y: this.bannerDeformState.bannerIconScale
      })
      .visibility(this.bannerDeformState?.useFakerIcon ? Visibility.Visible : Visibility.Hidden)
      .flexShrink(0)
  }

  @Builder
  buildHeadsUpItem() {
    if (this.isDropBarVisible) { // 带悬浮窗通知
      this.buildContentWithDropBar()
    } else { // 普通通知
      this.buildContent();
    }
  }

  @Builder
  buildNtfBanner() {
    if (!CommonUtils.isInvalid(this.ntfEntry)) {
      Column() {
        this.buildHeadsUpItem();
      }
      .visibility(!DeviceHelper.isPC() && this.closeVM?.deletingItem === this.ntfEntry ?
        Visibility.Hidden : Visibility.Visible)
      .onAreaChange(this.closeVM ? (oldValue, newValue) => {
        this.itemContentArea = newValue;
        this.closeVM?.updatePosition(this.ntfEntry!, this.itemContentArea!);
      } : undefined)
      .borderRadius(CardScaleUtil.getRadius(this.isOuterHomeFolded, this.radius))
      .foregroundBlurStyle(BlurStyle.Thin, {scale: this.blurScale})
      .width('100%')
      .useEffect(false)
      .hitTestBehavior(HitTestMode.None)
      .onHover(this.closeVM ? (isHover: boolean) => { this.onItemHoverChange(isHover) } : undefined)
      .onSizeChange((oldValue: SizeOptions, newArea: SizeOptions) => {
        this.bannerHeight = newArea.height as number;
      })
    }
  }

  @Builder
  buildNtfBannerBackground() {
    Stack()
      .backgroundColor((this.ntfEntry as NotificationEntry).isLiveType() ? this.colorModeVM?.liveHeadsUpBgColor :
        this.colorModeVM?.themeBannerBgColor)
      .backgroundBrightnessInternal((this.ntfEntry as NotificationEntry).isLiveType() ?
        this.colorModeVM?.liveBannerBgOptions : this.colorModeVM?.themeBannerBgOptions)
      .borderRadius(CardScaleUtil.getRadius(this.isOuterHomeFolded, this.radius))
      .width('100%')
      .height(this.isInitParam ? this.bannerDeformState.bannerHeight : this.bannerHeight)
      .backgroundEffect(this.colorModeVM?.headsUpBgEffect)
  }

  build() {
    Stack() {
      this.buildNtfBannerBackground();
      if (this.frameCount.value > 1) { // 分帧处理:从第2帧开始创建子组件
        this.buildNtfBanner();
      }
    }
    .borderRadius(CardScaleUtil.getRadius(this.isOuterHomeFolded, this.radius))
    .width(CardScaleUtil.getWidth(this.isOuterHomeFolded, undefined))
    .pixelRound({
      start: PixelRoundCalcPolicy.FORCE_CEIL,
      top: PixelRoundCalcPolicy.FORCE_CEIL,
      end: PixelRoundCalcPolicy.FORCE_FLOOR,
      bottom: PixelRoundCalcPolicy.FORCE_FLOOR
    })
    .scale(CardScaleUtil.getScale(this.isOuterHomeFolded, CardScaleType.SCALE_TOP_LEFT))
    .shadow(ShadowStyle.OUTER_DEFAULT_MD)
    .clip(true)
    .translate({ x: this.preHeadsUpItemTranX ?? this.headsUpItemTranX })
  }
  /**
   * 更新中景窗状态，用来判断当前横幅是否可以拉起悬浮窗。中景窗下，不允许横幅拉起悬浮窗
   * @param screenId 面板ID
   */
  updateMidScene(screenId: number): void {
    const containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList(screenId);
    const curSession = containerSessionList.getTopActiveSession();
    this.isMidScene = !!curSession?.isMidScene;
    log.showInfo(`update isMidScene: ${this.isMidScene}}`)
  }
}
