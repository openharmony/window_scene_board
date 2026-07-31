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
import { CC_LAYOUT_CONFIGS, ControlCenterLayoutIndex } from '../../controller/ControlCenterLayoutController';
import { ControlCenterAnimationData } from '../../model/ControlCenterAnimationData';
import ControlCenterMediaCardLayout from './ControlCenterMediaCardLayout';
import { FASlotName } from '@ohos/commonconstants';
import lazy {
  ExpandMediaCardComponent
} from '@ohos/mediacontrolcomponent/src/main/ets/default/pages/ExpandMediaCardComponent';
import { BrightnessSharedViewData } from '../../viewModel/BrightnessViewModel';
import { BackgroundOpacity } from '../../model/BrightnessViewData';
import TopToggleLoader from './TopToggleLoader';
import { ControlCenterHomeViewData } from '../../vm/ControlCenterHomeViewData';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import StyleConfiguration, {
  ControlCenterLongButtonLayoutStyle,
  SingleExpandLongButtonStyle
} from '../../common/StyleConfiguration';
import DropDownPanelManager, { PanelDismissReason } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { MEDIA_ROW_TOP_TOGGLES } from '../../common/Constants';

const TAG = 'Ctrl.TopToggleRow';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

@Component
export default struct TopToggleRow {
  private style: ControlCenterLongButtonLayoutStyle | SingleExpandLongButtonStyle =
    StyleConfiguration.getControlCenterLongButtonLayoutStyle();
  @State backgroundOpacity: BackgroundOpacity = BrightnessSharedViewData.getInstance().getBackgroundOpacity();
  @ObjectLink animationData: ControlCenterAnimationData;
  @StorageLink('isLandscape') isLandscape: boolean = false;
  @Prop slots: string[] = [];
  @Prop contentHeight: number = 0;
  @Prop viewData: ControlCenterHomeViewData = new ControlCenterHomeViewData();
  @Consume ccLayoutIndex: ControlCenterLayoutIndex;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear ccLayoutIndex: ${this.ccLayoutIndex}, ${this.slots.toString()} `);
  }

  @Styles
  animStyles(){
    .translate({ y: this.animationData.itemTranslate + Math.max(this.animationData.translate, 0) })
    .opacity(this.animationData.opacity)
    .scale({
      x: this.animationData.scale,
      y: this.animationData.scale
    })
  }

  @Builder
  loadFixedLayout(mediaLandscape: boolean = false) {
    if (this.ccLayoutIndex === ControlCenterLayoutIndex.FOLD_EXPANDED) {
      Row({ space: 36 }) {
        Column() {
          Column() {
            ExpandMediaCardComponent()
          }
          .animStyles()
          .transition(TransitionEffect.asymmetric(
            TransitionEffect.OPACITY.animation({
              delay: 20,
              duration: 200
            }),
            TransitionEffect.OPACITY.animation({
              duration: 10
            }),
          ))
        }
        .width(300)
        .height(this.contentHeight)
        .scale({
          x: this.viewData.largeMediaCardScale,
          y: this.viewData.largeMediaCardScale,
          centerY: 0
        })

        Row({ space: this.style.space }) {
          if (this.slots.includes(FASlotName.COMBINED_SLIDER) || this.slots.includes(FASlotName.BRIGHTNESS)) {
            TopToggleLoader({ toggleSlot: FASlotName.BRIGHTNESS })
          }
          if (this.slots.includes(FASlotName.COMBINED_SLIDER) || this.slots.includes(FASlotName.SOUND)) {
            TopToggleLoader({ toggleSlot: FASlotName.SOUND })
          }
          ForEach(this.slots, (item: string, index?: number) => {
            if (item !== FASlotName.MEDIA_ITEM_NAME && !MEDIA_ROW_TOP_TOGGLES.includes(item) &&
              item !== FASlotName.BRIGHTNESS && item !== FASlotName.SOUND) {
              TopToggleLoader({ toggleSlot: item })
            }
          }, (item: string, index?: number) => item)
        }
        .animStyles()
      }
      .opacity(this.viewData.mediaCardOpacity)
      .visibility(this.backgroundOpacity.backgroundOpacity === 1 ? Visibility.Visible : Visibility.Hidden)
      .width(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.mainPanelWidth)
      .height(64)
      .justifyContent(FlexAlign.End)
      .alignItems(VerticalAlign.Top)
      .clip(false)
    } else {
      // 固定布局：媒体(左) | 亮度+音量组合(右)，按槽位是否已添加决定显隐
      Row({ space: this.style.space }) {
        if (this.slots.includes(FASlotName.MEDIA_ITEM_NAME)) {
          ControlCenterMediaCardLayout({
            mediaLandscape: mediaLandscape
          })
            .opacity(this.viewData.mediaCardOpacity)
        }
        if (this.slots.includes(FASlotName.COMBINED_SLIDER) || this.slots.includes(FASlotName.BRIGHTNESS)) {
          TopToggleLoader({
            toggleSlot: FASlotName.BRIGHTNESS,
            isVerticalSlider: true
          })
        }
        if (this.slots.includes(FASlotName.COMBINED_SLIDER) || this.slots.includes(FASlotName.SOUND)) {
          TopToggleLoader({
            toggleSlot: FASlotName.SOUND,
            isVerticalSlider: true
          })
        }
        // 同槽位里其它顶栏项
        ForEach(this.slots, (item: string) => {
          if (!MEDIA_ROW_TOP_TOGGLES.includes(item) &&
            item !== FASlotName.BRIGHTNESS && item !== FASlotName.SOUND) {
            TopToggleLoader({ toggleSlot: item })
          }
        }, (item: string) => item)
      }
      .width(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.singleCardWidth)
      .height($r('app.float.Control_center_mediaAndWifiBlue_height'))
      .alignItems(VerticalAlign.Top)
      .animStyles()
      .visibility(this.backgroundOpacity.backgroundOpacity === 1 ? Visibility.Visible : Visibility.Hidden)
      .clip(false)
    }
  }

  @Builder
  loadCombinedLayout() {
    Row({ space: this.style.space }) {
      TopToggleLoader({ toggleSlot: FASlotName.COMBINED_SLIDER })
      Column({ space: this.style.rowSpace }) {
        ForEach(this.slots, (item: string, index?: number) => {
          if (item !== FASlotName.COMBINED_SLIDER) {
            TopToggleLoader({ toggleSlot: item })
          }
        }, (item: string, index?: number) => item)
        if (this.slots.length < 3) {
          Row()
            .width(this.style.newCardWidth)
            .height(this.slots.length === 1 ? this.style.newCardWidth : this.style.newCardHeight)
            .blankLayoutStyle()
        }
      }
    }
    .width(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.singleCardWidth)
    .reverse(this.slots.indexOf(FASlotName.COMBINED_SLIDER) > 0)
    .alignItems(VerticalAlign.Top)
    .animStyles()
  }

  @Styles
  blankLayoutStyle(){
    .gesture(TapGesture()
      .onAction(() => {
        log.showInfo('hide cc by grid blank area');
        DropDownPanelManager.setDismissReason(PanelDismissReason.CLICK_BLANK);
        DropDownPanelManager.animToDismiss();
      }))
    .accessibilityLevel('no')
    .focusable(false)
  }

  build() {
    // 含媒体或亮度音量组合：走固定媒体行布局（媒体 | 亮度 | 音量对齐）
    if (this.slots.some((item: string) => MEDIA_ROW_TOP_TOGGLES.includes(item) ||
      item === FASlotName.BRIGHTNESS || item === FASlotName.SOUND)) {
      this.loadFixedLayout(this.isLandscape)
    } else if (this.slots.includes(FASlotName.COMBINED_SLIDER)) {
      this.loadCombinedLayout()
    } else if (this.slots.length <= 2) {
      Row({ space: this.style.space }) {
        ForEach(this.slots, (item: string, index?: number) => {
          TopToggleLoader({ toggleSlot: item })
        }, (item: string, index?: number) => item)
        Row()
          .height(this.slots.includes(FASlotName.COMBINED_SLIDER) ? this.style.newCardWidth : this.style.newCardHeight)
          .layoutWeight(1)
          .blankLayoutStyle()
      }
      .width(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.singleCardWidth)
      .animStyles()
    }
  }
}