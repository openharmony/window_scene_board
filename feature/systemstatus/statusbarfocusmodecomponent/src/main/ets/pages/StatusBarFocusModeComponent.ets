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
import { LogDomain, Logger } from '@ohos/basicutils';
import StyleConfiguration from '../common/StyleConfiguration';
import { StartsBarFocusModeComponentStyle } from '../common/StyleConfiguration';
import { FocusModeData } from '../common/Constants';
import controller from '../controller/FocusModeController';
import { GlobalContext, PluginSlot } from '@ohos/frameworkwrapper';
import { AccessibilityVm } from '@ohos/systemuicommon/newIndex';
// instrument ignore file

const TAG = 'FocusMode-StatusBarFocusModeComponent';

const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

const COMPONENT_ID = TAG + '_Image_icon';

@Component
export default struct StatusBarFocusModeComponent {
  @State mFocusModeData: FocusModeData = controller.getData();
  @State style: StartsBarFocusModeComponentStyle = StyleConfiguration.getStartsBarFocusModeComponentStyle();
  @Consume contentColor: string;
  @StorageProp('focusModeIconId') mIconId: string = 'moon_fill';
  @StorageProp('focusModeName') modeName: string = '';

  aboutToAppear(): void {
    log.showInfo(TAG, 'aboutToAppear focus mode');
  }

  aboutToDisappear(): void {
    log.showInfo(TAG, 'aboutToDisappear focus mode');
  }

  private getAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled || !this.mFocusModeData.isFocusModeEnable) {
      return '';
    }
    try {
      const res = GlobalContext.getContext()?.resourceManager;
      const modeAccessibilityText = controller.getAccessibilityText(this.modeName);
      return modeAccessibilityText ?
        modeAccessibilityText : res.getStringByNameSync('accessibility_status_bar_focus_mode');
    } catch (err) {
      log.showError(TAG, `getAccessibilityText error, message is ${err?.message}, code is ${err?.code}`);
      return '';
    }
  }

  build() {
    Row() {
      SymbolGlyph($r(`sys.symbol.${this.mIconId}`))
        .draggable(false)
        .fontColor([this.contentColor])
        .id(COMPONENT_ID)
        .fontSize(this.style.statusBarFocusModeSize)
        .height(this.style.statusBarFocusModeHeight)
    }
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
    .height('100%')
  }
}