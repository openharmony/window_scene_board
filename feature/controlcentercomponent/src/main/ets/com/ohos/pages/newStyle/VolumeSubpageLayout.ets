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
import { soundSubPageController } from '@ohos/soundcomponent/src/main/ets/controller/SoundSubPageLayoutController';
import { VolumeSubpage } from '@ohos/soundcomponent/Index';

const TAG = 'Ctrl.VolumeSubpageLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

@Component
export default struct VolumeSubpageLayout {
  @Consume @Watch('ccLayoutIndexChange') ccLayoutIndex: ControlCenterLayoutIndex;
  @Provide flexDirection: FlexDirection = FlexDirection.Column;
  @Link contentHeight: number | string;

  private backToMainPage(event?: TouchEvent) {
    if (event?.type === TouchType.Up || event?.type === TouchType.Cancel) {
      log.showInfo(`BrightnessSubpageLayout touch event`)
      soundSubPageController.hideWindow();
    }
  }

  private ccLayoutIndexChange(): void {
    this.flexDirection =
      this.ccLayoutIndex === ControlCenterLayoutIndex.NORMAL_LANDSCAPE ? FlexDirection.Row : FlexDirection.Column;
  }

  aboutToAppear(): void {
    this.flexDirection =
      this.ccLayoutIndex === ControlCenterLayoutIndex.NORMAL_LANDSCAPE ? FlexDirection.Row : FlexDirection.Column;
  }

  build() {
    Stack() {
      this.loadBlankStack();
      Stack() {
        this.loadBlankStack();
        VolumeSubpage();
      }
      .width(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.panelWidth)
      .height(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.subpageVerticalCenter ? '100%' : this.contentHeight)
      .margin(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.panelMargin)
    }
    .direction(Direction.Ltr)
    .width('100%')
    .height('100%')
    .alignContent(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.panelAlignment)
  }

  @Builder
  loadBlankStack() {
    Stack() {
    }.width('100%')
    .height('100%')
    .onTouch((event) => {
      this.backToMainPage(event);
    })
  }
}