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
import DropDownPanelManager, { PanelDismissReason } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { ControlCenterLayoutIndex } from '../../controller/ControlCenterLayoutController';
import { ControlCenterAnimationData } from '../../model/ControlCenterAnimationData';
import StyleConfiguration, { SingleFoldLongButtonStyle } from '../../common/StyleConfiguration';
import { ToggleComponent } from '@ohos/controlcentercommon/src/main/ets/toggle/view/NewToggleBaseComponent';
import { SingleFoldFactory } from '../../SingleFoldStyle/SingleFoldStyleFactory';
import { QuickToggleController } from '../../controller/QuickToggleController';
import { ToggleTemplateType } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { ToggleScene } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';

const TAG = 'Ctrl.SingleFoldQuickToggleRow';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

@Component
export default struct SingleFoldQuickToggleRow {
  private readonly rowHeight: number = 60;
  private style: SingleFoldLongButtonStyle =
    StyleConfiguration.getSingleFoldLongButtonStyle();
  @ObjectLink animationData: ControlCenterAnimationData;
  @Prop slots: string[] = [];
  @Consume ccLayoutIndex: ControlCenterLayoutIndex;

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
  }

  build() {
    Row({space: this.style.space}) {
      ForEach(this.slots, (slot: string) => {
        ToggleComponent({
          toggleId: slot,
          toggleViewModel: QuickToggleController.getInstance().createToggleModelAndInit(slot),
          toggleStyle: SingleFoldFactory.getInstance().createBasicStyle(),
          templateType: ToggleTemplateType.BASIC,
          toggleScene: ToggleScene.SINGLE_FOLD_OUTER_SCREEN
        })
      }, (slot: string) => slot)
      Column()
        .layoutWeight(1)
        .height(this.rowHeight)
        .gesture(TapGesture()
          .onAction(() => {
            log.showInfo('hide cc by grid blank area');
            DropDownPanelManager.setDismissReason(PanelDismissReason.CLICK_BLANK);
            DropDownPanelManager.animToDismiss();
          }))
        .accessibilityLevel('no')
    }
    .width(this.style.singleCardWidth)
    .translate({ y: this.animationData.itemTranslate + Math.max(this.animationData.translate, 0) })
    .opacity(this.animationData.opacity)
    .scale({
      x: this.animationData.scale,
      y: this.animationData.scale
    })
  }
}