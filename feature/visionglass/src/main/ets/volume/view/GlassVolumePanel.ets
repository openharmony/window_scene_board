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

import { GlassLayoutManager } from '../../common/manager/GlassLayoutManager';
import { calculateSize } from '../../controlcenter/components/constants/WifiConstants';
import { GlassVolumePanelManager } from '../manager/GlassVolumePanelManager';
import { GlassVolumeModel } from '../models/GlassVolumeModel';
import { GlassVolumePanelStyle } from './GlassVolumePanelStyle';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlassSystemSceneManager, GlassSystemSceneType } from '../../scene/common/GlassSystemSceneManager';

const TAG = 'GlassVolumePanel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export default struct GlassVolumePanel {
  @State volumeInstance: GlassVolumeModel = new GlassVolumeModel();
  @State windowHeight: number = GlassLayoutManager.getInstance().getScreenHeightPx();

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    GlassSystemSceneManager.getInstance().hideSystemView(GlassSystemSceneType.GLASS_VOLUME);
    this.volumeInstance.init();
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    this.volumeInstance.unInit();
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Slider({
        value: this.volumeInstance.volumeValue,
        min: this.volumeInstance.minVolumeValue,
        max: this.volumeInstance.maxVolumeValue,
        style: SliderStyle.NONE,
        direction: Axis.Vertical,
        reverse: true,
      })
        .trackColor(GlassVolumePanelStyle.VOLUME_PANEL_TRACK_COLOR)
        .selectedColor(GlassVolumePanelStyle.VOLUME_PANEL_SELECTED_COLOR)
        .trackThickness(calculateSize(this.windowHeight, GlassVolumePanelStyle.VOLUME_PANEL_WIDTH_SCALE))
        .trackBorderRadius(calculateSize(this.windowHeight, GlassVolumePanelStyle.VOLUME_PANEL_WIDTH_SCALE))
        .onChange((value: number) => {
          this.volumeInstance.setVolume(value);
        })
        .width('100%')
        .height('100%')
      Row() {
        Image($r('app.media.glass_ic_public_volume_filled'))
          .width(GlassVolumePanelStyle.VOLUME_ICON_SIZE)
          .height(GlassVolumePanelStyle.VOLUME_ICON_SIZE)
          .fillColor(Color.Black)
          .hitTestBehavior(HitTestMode.Transparent)
      }
      .size({
        width: calculateSize(this.windowHeight, GlassVolumePanelStyle.VOLUME_PANEL_WIDTH_SCALE),
        height: calculateSize(this.windowHeight, GlassVolumePanelStyle.VOLUME_PANEL_WIDTH_SCALE)
      })
      .justifyContent(FlexAlign.Center)
      .hitTestBehavior(HitTestMode.Transparent)
    }
    .width(calculateSize(this.windowHeight, GlassVolumePanelStyle.VOLUME_PANEL_WIDTH_SCALE))
    .height(GlassVolumePanelStyle.VOLUME_PANEL_HEIGHT)
    .shadow({
      offsetX: GlassVolumePanelStyle.SHADOW_OFFSET_X,
      offsetY: GlassVolumePanelStyle.SHADOW_OFFSET_Y,
      radius: GlassVolumePanelStyle.SHADOW_OFFSET_RADIUS,
      color: GlassVolumePanelStyle.VOLUME_PANEL_SHADOW_COLOR,
    })
    .backgroundColor(GlassVolumePanelStyle.VOLUME_PANEL_BACKGROUND_COLOR)
    .borderRadius(calculateSize(this.windowHeight, GlassVolumePanelStyle.VOLUME_PANEL_WIDTH_SCALE))
    .onAreaChange((oldValue, newValue) => {
      GlassVolumePanelManager.getInstance().updatePosition(newValue);
    })
  }
}