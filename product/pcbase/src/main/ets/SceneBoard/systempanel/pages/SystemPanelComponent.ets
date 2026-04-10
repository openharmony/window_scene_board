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

import { Log } from '@ohos/basicutils';
import StyleConfiguration, { SystemPanelComponentStyle } from '../common/StyleConfiguration';
import { SystemPanelConfig, MenuLayout } from '../common/SystemPanelConfig';
import SystemMenu from './SystemMenu';

const TAG = 'SystemPanel-SystemPanelComponent';

@Component
export default struct SystemPanelComponent {
  @State style: SystemPanelComponentStyle = StyleConfiguration.getSystemPanelComponentStyle();
  @State globalClickable: boolean = false;
  systemPanelConfig: SystemPanelConfig = new SystemPanelConfig();

  aboutToAppear() {
    Log.showInfo(TAG, `SystemPanelComponent, aboutToAppear`);
    this.systemPanelConfig.init();
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `SystemPanelComponent, aboutToDisAppear`);
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      ForEach(this.systemPanelConfig.menuConfig, (menuLayout: MenuLayout, index: number) => {
        SystemMenu(
          {
            menuType: menuLayout.id,
            textContent: menuLayout.content,
            clickable: menuLayout.clickable,
            hasDivider: menuLayout.hasDivider,
            globalClickable: $globalClickable,
            isLastItem: index === this.systemPanelConfig.menuConfig.length - 1,
            needIcon: menuLayout.needIcon,
            iconKey: menuLayout.iconKey,
            isFirstItem: index === 0,
          }
        )
      });
    }
    .margin({
      top: StyleConfiguration.getSystemPanelComponentStyle().systemPanelMargin,
      bottom: StyleConfiguration.getSystemPanelComponentStyle().systemPanelMargin
    })
    .padding({ top: this.style.systemPanelComponentTopMargin, bottom: this.style.systemPanelComponentBottomMargin })
    .width('100%')
  }
}