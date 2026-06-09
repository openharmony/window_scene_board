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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBScreenProperty } from '@ohos/windowscene';
import {
  ClockOneShortConsts,
  SlAreaType,
  SlVisualControl,
  slWallpaperMgr,
  SLWallpaperState,
  WBaseProperty
} from '@ohos/screenlockcommon';
import {
  DisplayStateManager,
  EXIT_KEYGUARD,
  NONE_EDIT_MODE,
  BOUNCER_MODE,
  WidgetAnimState
} from '@ohos/screenlockcommon/Index';
import { MainColor } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/MainColor';
import ScreenLockFormViewModel from '@ohos/screenlockwidget/src/main/ets/form/vm/ScreenLockFormViewModel';
import { MainPageVc } from '../../controller/MainPageVc';
import ScreenLockFormPanel from '@ohos/screenlockwidget/src/main/ets/form/ScreenLockFormPanel';
import FormBorderView from '@ohos/screenlockwidget/src/main/ets/editsheet/views/FormBorderView';
import { SlWidgetId, SlWidgetZIndex } from '@ohos/screenlockcommon/src/main/ets/constants/SlWidgetConst';
import { AnyClock } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/AnyClock';
import { SlBindState } from '../../model/data/SlBindState';
import { LockManifest } from '@ohos/screenlockwidget/src/main/ets/common/theme/ThemeHelperUtil';
import { slStateHelper } from '../../model/helper/SlStateHelper';
import { SlClockBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockBindState';
import { SlClockLocateState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockLocateState';
import { SlFormBindState } from '@ohos/screenlockcomponent/src/main/ets/screenlockstate/model/data/SlFormBindState';
import { ScreenLockSpaceAniData } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockSpaceAniOptions';
import { clockLayoutHelper } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutHelper';
import ScreenLockSpaceAnimationViewModel
  from '@ohos/screenlockcomponent/src/main/ets/password/viewmodel/ScreenLockSpaceAnimationViewModel';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SlObserverProxy } from '@ohos/screenlockcomponent/src/main/ets/observer/SlObserverProxy';
import { MpStateType, MpStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/MainPageFsm';
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';
import { spaceAniHelper } from '@ohos/screenlockcommon/src/main/ets/manager/SpaceAniHelper';
import { ClockAdapterFactory, ClockLayout, UseScene } from '@ohos/screenlockwidget';
import { ClockBindData } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/ClockBindData';

const TAG = 'FormPanelView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Component
export struct FormPanelView {
  private persistentId: number = 0;
  private parentVc?: MainPageVc;

  @Link formViewModel: ScreenLockFormViewModel;
  @Link displayMode: number;
  @Link screenProp: SCBScreenProperty;
  @Link lockManifestParam: LockManifest;
  @Link @Watch('onClockStyleChange') clockStyle: AnyClock;
  @Link isShowFormBindSheet: boolean;
  @Link dragInfo: TranslateOptions;
  @Prop bgEffect: BackgroundEffectOptions | undefined;

  @State slBindState: SlBindState = slStateHelper.getSlBindState();
  @State slClockBindCtrl: SlClockBindState = slStateHelper.getSlClockBindState();
  @State clockBindState: ClockBindData = ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE)
    .getClockWidgetModel().getClockBindState();
  @State slClockLocateState: SlClockLocateState = slStateHelper.getSlClockLocateState();
  @State clockAnimState: WidgetAnimState = slStateHelper.getClockViewAnimSt();
  @State slClockAnimCtrl: WidgetAnimState = slStateHelper.getSlClockAnimCtrl();
  @State slWallpaperState: SLWallpaperState = slWallpaperMgr.getSlWallpaperState();
  @State stateType: MpStateType = ScreenLockFsmProxy.getInstance(this.persistentId).mainPageFsm.currentStateType;
  @State private formAniOpt: ScreenLockSpaceAniData = spaceAniHelper.getSpaceAniFormState();
  @State slFormAnimCtrl: WidgetAnimState = slStateHelper.getSlFormAnimState(); // 卡片组件动效状态管理
  @State slFormBindCtrl: SlFormBindState = slStateHelper.getSlFormBindState(); // 卡片组件UI样式状态管理

  @Consume mainColor: MainColor;
  @Consume gridWidth: number;
  private readonly slObserverProxy: SlObserverProxy = new SlObserverProxy();

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    // 服务卡片静态状态器
    this.formViewModel?.setSlFormStaticState(slStateHelper.getSlFormStaticState());
    this.slObserverProxy.getMpFsmState(this.persistentId, (oldState: MpStateType, newState: MpStateType): void => {
      this.stateType = newState;
    });
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.slObserverProxy.release();
  }

  private onClockStyleChange() {
    // 异常时钟样式不做处理
    if (this.clockStyle.layout < ClockLayout.DEFAULT_CLOCK_LAYOUT) {
      return;
    }
    this.formViewModel.updateLayout(this.clockStyle.layout, this.clockStyle.y);
  }

  build() {
    if (this.getFormPanelVisible()) { // 快捷卡片
      Stack() {
        if (MpStateTypeUtils.isEditState(this.stateType)) {
          FormBorderView({
            formViewModel: this.formViewModel,
            mainColorType: this.mainColor.colorType,
            displayMode: this.displayMode,
            isLightWallpaper: this.slWallpaperState.isLightWallpaper,
            gridWidth: this.gridWidth,
            formPositionY: this.getFormPositionY(),
            clockStyle: this.clockStyle,
          })
            .translate(this.getFormBorderTran())
        }

        if ((this.formViewModel && this.formViewModel.formConfigs.length > 0) ||
          ![NONE_EDIT_MODE, EXIT_KEYGUARD, BOUNCER_MODE].includes(this.displayMode)) {
          ScreenLockFormPanel({
            formPositionY: this.getFormPositionY(),
            mainColorType: this.mainColor.colorType,
            formViewModel: this.formViewModel,
            isShowFormBindSheet: this.isShowFormBindSheet,
            screenProp: this.screenProp,
            isLightWallpaper: this.parentVc?.getClockNeedToDarken(),
            aestheticColorArgs: this.parentVc?.getAestheticColorArgs(),
            clockStrokeColor: this.clockStyle.clockStrokeColor,
            persistentId: this.persistentId,
            clockStyle: this.clockStyle,
            bgEffect: this.bgEffect,
            longPressGesture: () => {
              this.parentVc?.getViewModel()?.longPressFormPanel();
            }
          })
            .translate(this.getFormTran())
        }
      }
      .opacity(this.getFormPanelOpacity())
      .zIndex(SlWidgetZIndex.Z_INDEX_FORM)
      .visibility(Visibility.Visible)
      .alignRules({
        top: { anchor: SlWidgetId.CLOCK, align: VerticalAlign.Bottom },
        middle: { anchor: SlWidgetId.CLOCK, align: HorizontalAlign.Center }
      })
      .onAreaChange((old, newArea) => {
        SlVisualControl.getInstance().updateComponentArea(SlAreaType.FORM, newArea);
      })
    }
  }

  private getFormPanelVisible(): boolean {
    let isUnlocked: boolean = this.slBindState.isOsAccountUnlocked();
    let isThemeConfigVisible: boolean = this.lockManifestParam.clockVisible && this.lockManifestParam.formVisible;
    return isUnlocked && isThemeConfigVisible;
  }

  private getFormBorderTran(): TranslateOptions {
    return {
      x: this.slClockBindCtrl.getClockBorderLeftMargin(),
      y: this.slClockBindCtrl.getClockBorderTopMargin(),
    };
  }

  private getFormTran(): TranslateOptions | undefined {
    if (this.slClockAnimCtrl?.isSceneAnimating() && DeviceHelper.isUltraScreenProduct()) {
      return {
        x: this.slClockAnimCtrl.getTranX() ?? 0,
        y: this.slClockAnimCtrl.getTranY() ?? 0,
      };
    }
    if (this.clockAnimState?.isWidgetAnimating()) { // 动效优先
      return {
        y: this.clockAnimState?.getTranY() ?? 0
      };
    }
    return this.dragInfo;
  }

  private getFormPanelOpacity(): number {
    // 空间感
    if (ScreenLockSpaceAnimationViewModel.isSpaceUnlockAnimation()) {
      log.debug(`getFormPanelOpacity ${this.formAniOpt.getSpaceOpacity()}`);
      return this.formAniOpt.getSpaceOpacity();
    }

    // AOD到桌面时钟一镜到底
    if (this.slClockBindCtrl.getClockAodToDesktop()) {
      log.debug(`getFormPanelOpacity aod to desk 0`);
      return 0;
    }

    if (this.slClockBindCtrl.getClockDesktopToAod()) {
      log.debug(`getFormPanelOpacity desktop to aod ${this.slClockBindCtrl.getCurrentAnimScene()}`);
      if (this.slClockBindCtrl.getCurrentAnimScene() === ClockOneShortConsts.DESKTOP_TO_FULL_AOD_CLOCK_ANIMATION) {
        return this.clockBindState.noTimeViewOpacity;
      }
      return 0;
    }

    let alpha = this.slFormBindCtrl.getLayoutOpacity();
    log.debug(`getFormPanelOpacity clockbind alpha:${alpha}`);
    if (this.slFormAnimCtrl?.isSceneAnimating() && !this.slClockBindCtrl.isInDesktopAndAodClockOneShot()) {
      alpha = this.slFormAnimCtrl?.getStateValue(WBaseProperty.ALPHA) as number ?? 1;
      log.debug(`getFormPanelOpacity anim alpha:${alpha}`);
    }
    log.debug(`getFormPanelOpacity global alpha:${this.slBindState.getOpacity()}`);
    return alpha * (1 - this.slBindState.getOpacity() / 150);
  }

  private getFormPositionY(): number {
    let isPortrait: boolean = DisplayStateManager.getInstance().isPortrait();
    let isFoldExpanded: boolean = DisplayStateManager.getInstance().isFoldExpanded();
    let layoutHeight: number = clockLayoutHelper.getLayoutAmount(isPortrait, isFoldExpanded).y;
    let clockHeight: number = this.clockStyle.getGridAmountHeight();
    return layoutHeight - this.clockStyle.y - clockHeight;
  }
}