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

import { StatusBarVmInjector, DeviceInfoVm, LiveCapsuleListView,
  LiveVmInjectorFactory, CutoutVm, IStatusBarPaddingVm, EnvVm, ResourceVm,
  AccessibilityVm, DropdownVm} from '@ohos/systemuicommon/newIndex';
import lazy { IMouseTypeStyleVm, ExtraPadding, MouseClickType, MouseHoverType, } from '@ohos/systemuicommon/newIndex';
import { LengthMetrics } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, PluginInfo, PluginSlot } from '@ohos/frameworkwrapper';
import { StatusBarIconWrapper } from './StatusBarIconWraper';
import { StatusBarBackground } from '../pages/StatusBarBackground';
import { GroupBackgroundEffect } from '../pages/GroupBackgroundEffect';
import { StatusBarMoveDownVmV2 } from '@ohos/systemuicommon/src/main/ets/statusbar/vm/StatusBarMoveDownVm';
import { StatusBarPrivacyIndicator } from '../pages/StatusBarPrivacyIndicator';
import { RTLUtil } from '@ohos/componenthelper';
import { StatusBarClockIconVm } from '../vm/StatusBarClockIconVm';
import { LayoutUtils, scbStatusBarStatusManager, XTLayoutType } from '@ohos/systemuicommon';
import { StatusBarType } from '@ohos/systemuicommon';
import { BackGroundEffectType } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarEnum';
import { StatusBarTint } from '../common/StatusBarTint';
import { StatusBarExternalVm } from '@ohos/systemuicommon/src/main/ets/vm/StatusBarExternalVm';
// instrument ignore file

const TAG = 'StatusBarView'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ComponentV2
export struct StatusBarView {
  @Consumer() statusBarVmInjector: StatusBarVmInjector = StatusBarVmInjector.HOLDER;
  @Param isEnableMouseTypeStyle: boolean = false;
  statusBarLayoutVm = this.statusBarVmInjector.getStatusBarLayoutVm();
  statusBarIconListVm = this.statusBarVmInjector.getStatusBarIconListVm();
  settingVM = this.statusBarVmInjector.getStatusBarSettingVm();
  statusBarAnimVm = this.statusBarVmInjector.getStatusBarAnimVm();
  deviceInfoVm = DeviceInfoVm.instance;
  capsuleListVm = LiveVmInjectorFactory.get().getCapsuleListVm();
  cutoutVm = CutoutVm.instance;
  statusBarMoveDownVm = StatusBarMoveDownVmV2.getInstance();
  resourceVm = ResourceVm.instance;
  accMode = AccessibilityVm.instance;
  envVm = EnvVm.instance;
  dropdownVm = DropdownVm.instance;

  // 状态栏常驻显示三大件
  clockVm = this.statusBarVmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_CLOCK) as StatusBarClockIconVm;
  signalVm = this.statusBarVmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_SIGNAL);
  batteryVm = this.statusBarVmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_BATTERY);
  mouseTypeStyleVm?: IMouseTypeStyleVm;

  /**
   * 状态栏实况界面刷新队列，数据相互依赖，刷新流程调整需要谨慎！
   */
  @Monitor('cutoutVm.top', 'cutoutVm.position', 'cutoutVm.left', 'cutoutVm.right', 'cutoutVm.orientation')
  public viewLayoutRefreshQueue() {
    log.showInfo(`viewLayoutRefreshQueue ${this.cutoutVm.left} ${DeviceInfoVm.instance.width}`)
    this.statusbarPaddingVm.updateStatusBarPadding();
    this.statusBarLayoutVm.statusbarLayoutRefresh(); // 刷新状态栏布局
    LiveVmInjectorFactory.get().getCapsuleListVm().onCutoutChange(); // 胶囊依据挖孔、左右限制和最新的position 更新胶囊使用的空间
    LiveVmInjectorFactory.get().getLiveHeadsUpVm().onCutoutChange(); // 实况面板侧挖孔更新
    this.statusBarLayoutVm.recalculateBaseLayoutWithoutAnimation(); // 触发状态栏基础胶囊布局刷新
  }

  @Computed
  get statusbarPaddingVm(): IStatusBarPaddingVm {
    return this.statusBarVmInjector.getStatusBarPaddingVm();
  }

  @Monitor('dropdownVm.isDropDown', 'dropdownVm.oneMirrorAnimating')
  onDropdownShowChange(): void {
    this.statusBarLayoutVm.onDropdownShowChange();
    LiveVmInjectorFactory.get().getCapsuleListVm().onDropdownShowChange();

  }

  /**
   * 状态栏常驻显示图标三大件宽度变化时触发胶囊布局更新，与挖孔信息变化区分开
   */
  @Monitor('clockVm.statusBarClockNormalWidth', 'signalVm.width', 'batteryVm.width')
  public permanentPluginWidthChangeRefreshQueue(monitor: IMonitor) {
    this.statusBarLayoutVm.statusbarLayoutRefresh();
    LiveVmInjectorFactory.get().getCapsuleListVm().capsuleLayoutRefresh();
  }

  @Monitor('resourceVm.isRTL')
  onLanguageChange(): void {
    this.statusBarLayoutVm.onLanguageChange();
    // F态挖孔不是正居中，G态挖孔不对称，需要更新胶囊位置信息
    if (LayoutUtils.isXTProductType() && this.deviceInfoVm.xtLayoutType === XTLayoutType.F) {
      LiveVmInjectorFactory.get().getCapsuleListVm().capsuleLayoutRefresh();
    }
    if (DeviceHelper.isPad()) {
      this.handleCapsuleAvoidAreaRefresh();
    }
  }

  @Monitor('statusBarLayoutVm.isShowFullScreenTitleBar')
  onTitleBarVisibilityChange(): void {
    log.showInfo(`onTitleBarVisibilityChange`);
    this.handleCapsuleAvoidAreaRefresh();
  }

  private handleCapsuleAvoidAreaRefresh(): void {
    this.statusBarLayoutVm.statusbarLayoutRefresh();
    this.statusBarLayoutVm.recalculateLayout(false);
    scbStatusBarStatusManager.setNeedStatusBarKeepShowing(false);
    LiveVmInjectorFactory.get().getCapsuleListVm().capsuleLayoutRefresh();
  }

  aboutToAppear(): void {
    log.showInfo(`about to appear, init StatusBarView`);
    this.statusBarLayoutVm.statusBarViewLayoutEnable = false;
    this.statusBarIconListVm.init();
    this.statusBarLayoutVm.init();
    this.settingVM.init();
    this.statusbarPaddingVm.init();
    this.statusBarAnimVm.init();
    this.capsuleListVm.init(this.statusBarLayoutVm.capsulePosition,
      this.statusBarLayoutVm.onCapsulePositionChange,
      this.statusBarAnimVm.onStatusBarChange);
    this.viewLayoutRefreshQueue();
    if (this.isEnableMouseTypeStyle) {
      this.mouseTypeStyleVm = this.statusBarVmInjector.getMouseTypeStyleVm()
    }
    setTimeout(() => {
      this.statusBarLayoutVm.statusBarViewLayoutEnable = true;
      log.showInfo(`about to appear, init StatusBarView finish`);
      this.statusBarLayoutVm.recalculateLayout(false);
    }, 0)
  }

  aboutToDisappear(): void {
    log.showInfo(`about to aboutToDisappear, unInit StatusBarView`);
    this.statusbarPaddingVm.unInit();
    this.statusBarVmInjector.getStatusBarSettingVm().unInit();
    log.showInfo(`about to aboutToDisappear, unInit StatusBarView finish`);
  }

  @Builder
  creatLeftIcons() {
    RelativeContainer() {
      if (this.statusBarLayoutVm.layoutIsVisibleIcons.has(PluginSlot.SLOT_STATUS_CLOCK)) {
        GroupBackgroundEffect({
          effectName: 'left_group',
          leftAnchorBindId: this.statusBarVmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_CLOCK).id,
          rightAnchorBindId: this.statusBarVmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_CLOCK).id,
          effectType: BackGroundEffectType.backgroundShadow,
        })
      }
      Repeat(this.statusBarIconListVm.leftIcons)
        .each((repeatItem: RepeatItem<PluginInfo>) => {
          StatusBarIconWrapper({
            iconVm: this.statusBarVmInjector.getStatusBarIconVm(repeatItem.item.pluginParseInfo.pluginSlot),
            isEnableMouseTypeStyle: this.isEnableMouseTypeStyle,
            isLeftIcon: true,
          }) {
            this.statusBarVmInjector.getStatusBarIconVm(repeatItem.item.pluginParseInfo.pluginSlot).getBuilder()
              .builder(repeatItem.item)
          }
        }).key((item: PluginInfo, index: number) => {
        return item.pluginParseInfo.pluginSlot;
      })
    }
    .height($r('app.float.status_bar_default_height'))
  }

  @Builder
  gradientBackground() {
    Stack()
      .width('100%')
      .height($r('app.float.status_bar_outer_home_height'))
      .linearGradient({
        direction: GradientDirection.Bottom,
        colors: StatusBarTint.OUTER_BG_GRADIENT_COLOR
      })
  }

  build() {
    EffectComponent() {
      Stack({ alignContent: Alignment.TopStart }) {
        if (EnvVm.instance.statusBarType !== StatusBarType.TYPE_MAIN_PHONE_DROPDOWN) {
          StatusBarBackground()
        }
        if (this.statusBarMoveDownVm.fakeLightShow) {
          StatusBarPrivacyIndicator()
        }
        if (this.isEnableMouseTypeStyle) {
          this.MouseStyleLeftGroup()
        }
        Stack () {
          this.creatLeftIcons();
        }
        .id('sbg_left')
        .accessibilityLevel('no')
        .scale({
          x: this.statusBarAnimVm.scaleXLeft, centerX: '0%',
        })
        .translate({x: this.statusBarAnimVm.leftGroupTranslateX})
        .position({
          start: new LengthMetrics(this.statusbarPaddingVm.statusBarLeftPadding - this.statusBarAnimVm.offsetX),
          top: new LengthMetrics(this.statusBarMoveDownVm.curMoveDis + this.statusbarPaddingVm.statusBarTopPadding)
        })
        .opacity(this.statusBarAnimVm.leftGroupOpacity)

        if (this.isEnableMouseTypeStyle) {
          this.MouseStyleRightGroup();
        } else {
          this.normalRightGroup();
        }
      }
      .width('100%')
      .height('100%')
      .id(TAG)
      .accessibilityLevel('no')
      .monopolizeEvents(true)
      .renderGroup(this.statusBarMoveDownVm.curMoveDis > 0 ? false : this.statusBarIconListVm.isRenderGroupEnable)
      .foregroundEffect({ radius: this.statusBarAnimVm.blurRadiusLeft })
      // 中挖孔的挂孔胶囊
      if (this.cutoutVm.isMiddleCutout()) {
        Stack() {
          LiveCapsuleListView()
        }
        .id(`${TAG}_LiveCapsuleListContainer`)
        .width(this.statusBarLayoutVm.capsulePosition.width)
        .height(this.statusBarLayoutVm.capsulePosition.height)
        .position({
          start: LengthMetrics.vp(this.statusBarLayoutVm.capsulePosition.left),
          top: LengthMetrics.vp(this.statusBarLayoutVm.capsulePosition.top)
        })
      }
    }
    .backgroundEffect({
      policy: 1,
      radius: 30
    })
  }

  @Builder
  MouseStyleLeftGroup() {
    Row() {
    }.id('MouseStyleLeftGroup')
    .backgroundColor(this.mouseTypeStyleVm?.leftBackgroundColor)
    .borderRadius(20)
    .height(28)
    .width(this.mouseTypeStyleVm?.leftGroupWidth)
    .position({
      start: new LengthMetrics(this.statusbarPaddingVm.statusBarLeftPadding -
      this.statusBarAnimVm.offsetX - ExtraPadding.LEFT),
      top: new LengthMetrics(this.statusbarPaddingVm.statusBarTopPadding +
      this.statusBarMoveDownVm.curMoveDis - ExtraPadding.TOP)
    })
  }

  private getLeftEffectAnchor(): string {
    if (this.statusBarLayoutVm.layoutIsVisibleIcons.has(PluginSlot.SLOT_STATUS_EARPHONE)) {
      return this.statusBarVmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_EARPHONE).id;
    }
    return this.statusBarIconListVm.getRightIconAnchorInfo(PluginSlot.SLOT_STATUS_EARPHONE);
  }

  @Builder
  normalRightGroup() {
    RelativeContainer() {
      if (this.statusBarLayoutVm.layoutIsVisibleIcons.has(PluginSlot.SLOT_STATUS_BATTERY)) {
        GroupBackgroundEffect({
          effectName: 'right_group',
          leftAnchorBindId: this.getLeftEffectAnchor(),
          rightAnchorBindId: this.statusBarVmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_BATTERY).id,
          effectType: BackGroundEffectType.backgroundShadow,
        })
      }
      Repeat(this.statusBarVmInjector.getStatusBarIconListVm().rightIcons)
        .each((repeatItem: RepeatItem<PluginInfo>) => {
          StatusBarIconWrapper({
            iconVm: this.statusBarVmInjector.getStatusBarIconVm(repeatItem.item.pluginParseInfo.pluginSlot),
          }) {
            this.statusBarVmInjector.getStatusBarIconVm(repeatItem.item.pluginParseInfo.pluginSlot).getBuilder()
              .builder(repeatItem.item)
          }
        }).key((item: PluginInfo, index: number) => {
        return item.pluginParseInfo.pluginSlot;
      })
    }
    .id('sbg_right')
    .height($r('app.float.status_bar_default_height'))
    .position({
      end: new LengthMetrics(this.statusbarPaddingVm.statusBarRightPadding - this.statusBarAnimVm.offsetX),
      top: new LengthMetrics(this.statusbarPaddingVm.statusBarTopPadding + this.statusBarMoveDownVm.curMoveDis)
    })
    .accessibilityLevel('no')
    .hitTestBehavior(HitTestMode.None)
    .scale({
      x: this.statusBarAnimVm.scaleXRight, centerX: '100%',
    })
    .translate({x: this.statusBarAnimVm.rightGroupTranslateX})
    .opacity(this.statusBarAnimVm.rightGroupOpacity)
  }

  @Builder
  MouseStyleRightGroup() {
    Row() {
      Row() {
        Repeat(this.statusBarVmInjector.getStatusBarIconListVm().rightIcons)
          .each((repeatItem: RepeatItem<PluginInfo>) => {
            StatusBarIconWrapper({
              iconVm: this.statusBarVmInjector.getStatusBarIconVm(repeatItem.item.pluginParseInfo.pluginSlot),
            }) {
              this.statusBarVmInjector.getStatusBarIconVm(repeatItem.item.pluginParseInfo.pluginSlot).getBuilder()
                .builder(repeatItem.item)
            }
          }).key((item: PluginInfo, index: number) => {
          return item.pluginParseInfo.pluginSlot;
        })
      }.height($r('app.float.status_bar_default_height'))
    }
    .id('MouseStyleRightGroup')
    .justifyContent(FlexAlign.End)
    .accessibilityLevel('no')
    .scale({
      x: this.statusBarAnimVm.scaleXRight, centerX: '100%',
    })
    .translate({x: this.statusBarAnimVm.rightGroupTranslateX})
    .position({
      end: new LengthMetrics(this.statusbarPaddingVm.statusBarRightPadding -
      this.statusBarAnimVm.offsetX - ExtraPadding.RIGHT),
      top: new LengthMetrics(this.statusbarPaddingVm.statusBarTopPadding +
      this.statusBarMoveDownVm.curMoveDis - ExtraPadding.TOP)
    })
    .hitTestBehavior(this.accMode.isEnabled ? HitTestMode.None : HitTestMode.Default)
    .backgroundColor(this.mouseTypeStyleVm?.rightBackgroundColor)
    .padding({left: ExtraPadding.RIGHT, top: ExtraPadding.TOP,
      bottom: ExtraPadding.TOP, right: ExtraPadding.RIGHT})
    .borderRadius(20)
    .onMouse((event: MouseEvent) => {
      this.mouseTypeStyleVm?.onMouseClick(event, MouseClickType.CLICK_RIGHT);
    })
    .onHover((isHover?: boolean) => {
      this.mouseTypeStyleVm?.onMouseHover(isHover, MouseHoverType.HOVER_RIGHT);
    })
  }
}