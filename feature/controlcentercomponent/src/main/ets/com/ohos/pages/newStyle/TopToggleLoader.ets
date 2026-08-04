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
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { ToggleComponent } from '@ohos/controlcentercommon/src/main/ets/toggle/view/NewToggleBaseComponent';
import {
  ToggleScene,
  ToggleTemplateType
} from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { CC_LAYOUT_CONFIGS, ControlCenterLayoutIndex } from '../../controller/ControlCenterLayoutController';
import { PhoneStyleFactory } from '../../phoneStyle/PhoneStyleFactory';
import { FASlotName } from '@ohos/commonconstants';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import { QuickToggleController } from '../../controller/QuickToggleController';
import BrightnessSliderButton from './BrightnessSliderButton';
import { VolumeSliderButton, soundSubPageController } from '@ohos/soundcomponent';
import { BrightnessSharedViewData } from '../../viewModel/BrightnessViewModel';
import { BackgroundOpacity } from '../../model/BrightnessViewData';
import StyleConfiguration, {
  ControlCenterLongButtonLayoutStyle,
  SingleExpandLongButtonStyle
} from '../../common/StyleConfiguration';
import {
  sBrightnessSubPageLayoutController as brightnessSubPageController
} from '../../controller/BrightnessSubPageLayoutController';
import { LengthMetrics } from '@kit.ArkUI';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import ControlCenterMediaCardLayout from './ControlCenterMediaCardLayout';

const TAG = 'Ctrl.TopToggleLoader';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

@Component
export default struct TopToggleLoader {
  public toggleSlot: string = '';
  public isEditMode: boolean = false;
  /** 与媒体卡同行时使用竖向滑条 */
  public isVerticalSlider: boolean = false;
  /** 备选库等场景关闭共享元素动效，避免与主页/预览区冲突 */
  public enableGeometryTransition: boolean = true;
  public style: ControlCenterLongButtonLayoutStyle | SingleExpandLongButtonStyle =
    StyleConfiguration.getControlCenterLongButtonLayoutStyle();
  private isIntelligentSceneEnable: boolean = AppStorage.get<boolean>('IntelligentSceneEnable') ?? false;
  @StorageLink('isLandscape') isLandscape: boolean = false;
  @State backgroundOpacity: BackgroundOpacity = BrightnessSharedViewData.getInstance().getBackgroundOpacity();
  @StorageLink('ControlCenterState') controlCenterState: ControlCenterState = ControlCenterState.MAIN_LAYOUT;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @Consume ccLayoutIndex: ControlCenterLayoutIndex;

  aboutToAppear(): void {
    log.showInfo('aboutToAppear ' + this.toggleSlot);
  }

  /**
   * 媒体行亮度/音量：添加后与组合滑条均使用竖向
   */
  private useVerticalSlider(): boolean {
    return this.isVerticalSlider;
  }

  private getGeometryTransitionId(slot: string): string {
    const baseId: string = slot + CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.showMediaAboveCardToggles;
    return this.enableGeometryTransition ? baseId : `${baseId}_library`;
  }

  @Builder
  mediaCardBuilder() {
    Row() {
      ControlCenterMediaCardLayout({ skipGeometryTransition: !this.enableGeometryTransition })
    }
    .accessibilityGroup(this.isEditMode && this.isAccessibilityMode)
    .accessibilityLevel(this.isEditMode && this.isAccessibilityMode ? 'no' : 'auto')
    .visibility(this.backgroundOpacity.backgroundOpacity === 1 || this.isEditMode ?
      Visibility.Visible : Visibility.Hidden)
    .borderRadius($r('app.float.Control_center_meidaCard_radius'))
    .width($r('app.float.Control_center_meidaCard_width'))
    .height($r('app.float.Control_center_meidaCard_width'))
  }

  @Builder
  sliderButtonBuilder() {
    if (this.toggleSlot === FASlotName.BRIGHTNESS &&
      (this.controlCenterState !== ControlCenterState.BRIGHTNESS_SUBPAGE ||
        this.controlCenterState === ControlCenterState.BRIGHTNESS_SUBPAGE &&
          !brightnessSubPageController.isHorizontal())) {
      BrightnessSliderButton({ isEditMode: this.isEditMode, isHorizontal: !this.useVerticalSlider() })
        .accessibilityGroup(this.isEditMode && this.isAccessibilityMode)
        .accessibilityLevel(this.isEditMode && this.isAccessibilityMode ? 'no' : 'auto')
        .visibility((this.useVerticalSlider() ? this.backgroundOpacity.verticalBrightOpacity :
          this.backgroundOpacity.horizontalBrightOpacity) === 1 || this.isEditMode ?
          Visibility.Visible : Visibility.Hidden)
        .id(this.useVerticalSlider() ? 'topBarBrightnessSliderButton' : 'brightnessSliderButton');
    } else if (this.toggleSlot === FASlotName.SOUND &&
      (this.controlCenterState !== ControlCenterState.SOUND_SUB_PAGE ||
      this.controlCenterState === ControlCenterState.SOUND_SUB_PAGE && !soundSubPageController.isHorizontal())) {
      VolumeSliderButton({ isEditMode: this.isEditMode, isHorizontal: !this.useVerticalSlider() })
        .accessibilityGroup(this.isEditMode && this.isAccessibilityMode)
        .accessibilityLevel(this.isEditMode && this.isAccessibilityMode ? 'no' : 'auto')
        .visibility(this.backgroundOpacity.backgroundOpacity === 1 || this.isEditMode ?
          Visibility.Visible : Visibility.Hidden)
        .id(this.useVerticalSlider() ? 'topBarVolumeSliderButton' : 'volumeSliderButton');
    } else {
      Stack()
        .width($r('app.float.Control_center_long_button_width'))
        .height($r('app.float.Control_center_long_button_height'))
    }
  }

  @Builder
  combinedSliderLayout() {
    if (this.isEditMode) {
      Stack() {
        this.combinedSlider();
        // 边框增加宽度间距，防止与内容重叠
        Row()
          .size(this.getCombinedSliderSize(3))
          .border({
            width: 1.5,
            color: '#80ffffff',
            radius: 32,
            style: BorderStyle.Dashed,
            dashWidth: LengthMetrics.vp(4),
            dashGap: LengthMetrics.vp(4)
          })
      }
      .size(this.getCombinedSliderSize())
    } else {
      this.combinedSlider();
    }
  }

  private getCombinedSliderSize(extraSize: number = 0): SizeOptions {
      return {
        width: ResUtils.getNumber($r('app.float.Control_center_long_button_width')) + extraSize,
        height: ResUtils.getNumber($r('app.float.Control_center_long_button_width')) + extraSize
      }
  }

  @Builder
  combinedSlider() {
    Row({ space: this.style.space }) {
      if (this.controlCenterState !== ControlCenterState.BRIGHTNESS_SUBPAGE ||
        this.controlCenterState === ControlCenterState.BRIGHTNESS_SUBPAGE &&
        brightnessSubPageController.isHorizontal()) {
        BrightnessSliderButton({ isEditMode: this.isEditMode, isHorizontal: false })
          .visibility(this.backgroundOpacity.verticalBrightOpacity === 1 || this.isEditMode ?
            Visibility.Visible : Visibility.Hidden)
          .id('combinedBrightnessSliderButton');
      } else {
        Stack()
          .height($r('app.float.Control_center_long_button_width'))
          .width($r('app.float.Control_center_long_button_height'))
      }

      if (this.controlCenterState !== ControlCenterState.SOUND_SUB_PAGE ||
        this.controlCenterState === ControlCenterState.SOUND_SUB_PAGE &&
        soundSubPageController.isHorizontal()) {
        VolumeSliderButton({ isEditMode: this.isEditMode, isHorizontal: false })
          .visibility(this.backgroundOpacity.backgroundOpacity === 1 || this.isEditMode ?
            Visibility.Visible : Visibility.Hidden)
          .id('combinedVolumeSliderButton');
      } else {
        Stack()
          .height($r('app.float.Control_center_long_button_width'))
          .width($r('app.float.Control_center_long_button_height'))
      }
    }
    .accessibilityGroup(this.isEditMode && this.isAccessibilityMode)
    .accessibilityLevel(this.isEditMode && this.isAccessibilityMode ? 'no' : 'auto')
  }

  @Builder
  loadLongButtonLayout(slot: string) {
    Row() {
      if (this.controlCenterState !== ControlCenterState.SUB_PANEL ||
        sToggleSubWindowController.getCurrentSubPanelSlot() !== slot) {
        ToggleComponent({
          isEditMode: this.isEditMode,
          toggleId: slot,
          toggleViewModel: QuickToggleController.getInstance().createToggleModelAndInit(slot),
          toggleStyle: PhoneStyleFactory.getInstance().createTaggedStyle(),
          templateType: ToggleTemplateType.TAGGED,
          toggleScene: ToggleScene.PHONE
        })
          .borderRadius($r('app.float.Control_center_long_button_radius'))
          .id('transition_topToggle' + slot + (this.isEditMode ? 'edit' : '') +
            (this.enableGeometryTransition ? '' : '_library'))
          .geometryTransition(this.getGeometryTransitionId(slot))
      }
    }
    .accessibilityGroup(this.isEditMode && this.isAccessibilityMode)
    .accessibilityLevel(this.isEditMode && this.isAccessibilityMode ? 'no' : 'auto')
    .visibility(this.backgroundOpacity.backgroundOpacity === 1 ? Visibility.Visible : Visibility.Hidden)
    .borderRadius($r('app.float.Control_center_long_button_radius'))
    .width(this.style.newCardWidth)
    .height(this.style.newCardHeight)
  }

  build() {
    // 超级终端开关已下线，不再渲染
    if (this.toggleSlot === FASlotName.SUPER_DEVICE) {
      // no-op
    } else if (this.toggleSlot === FASlotName.FOCUS_MODE) {
      if (this.isIntelligentSceneEnable) {
        this.loadLongButtonLayout(FASlotName.SCENARIO_MODE)
      } else {
        this.loadLongButtonLayout(FASlotName.FOCUS_MODE)
      }
    } else if (this.toggleSlot === FASlotName.MEDIA_ITEM_NAME) {
      this.mediaCardBuilder();
    } else if (this.toggleSlot === FASlotName.BRIGHTNESS || this.toggleSlot === FASlotName.SOUND) {
      this.sliderButtonBuilder();
    } else if (this.toggleSlot === FASlotName.COMBINED_SLIDER) {
      this.combinedSliderLayout();
    } else {
      this.loadLongButtonLayout(this.toggleSlot)
    }
  }
}