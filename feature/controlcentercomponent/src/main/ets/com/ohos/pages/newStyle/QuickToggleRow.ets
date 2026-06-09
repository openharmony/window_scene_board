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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import DropDownPanelManager, { PanelDismissReason } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { ToggleComponent } from '@ohos/controlcentercommon/src/main/ets/toggle/view/NewToggleBaseComponent';
import { ToggleTemplateType } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { CC_LAYOUT_CONFIGS, ControlCenterLayoutIndex } from '../../controller/ControlCenterLayoutController';
import { QuickToggleController } from '../../controller/QuickToggleController';
import { ControlCenterAnimationData } from '../../model/ControlCenterAnimationData';
import { PhoneStyleFactory } from '../../phoneStyle/PhoneStyleFactory';
import { ToggleScene } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';

const TAG = 'Ctrl.QuickToggleRow';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

@Component
export default struct QuickToggleRow {
  private readonly rowHeight: number = 84;
  @State space: number = ResUtils.getConvertNumber($r('app.float.Control_center_mediaAndWifiBlue_spaceBetween'));
  @ObjectLink animationData: ControlCenterAnimationData;
  @StorageLink('isLandscape') @Watch('onOrientationChanged') isLandscape: boolean = false;
  @Prop slots: string[] = [];
  @Consume ccLayoutIndex: ControlCenterLayoutIndex;

  aboutToAppear(): void {
    log.showInfo('aboutToAppear' + this.slots.toString());
    this.updateQuickToggleStyle();
  }

  updateQuickToggleStyle(): void {
  }

  /**
   * 横竖屏切换回调
   */
  onOrientationChanged() {
    this.updateQuickToggleStyle();
  }

  build() {
    Row({ space: this.space }) {
      ForEach(this.slots, (slot: string) => {
        ToggleComponent({
          toggleId: slot,
          toggleViewModel: QuickToggleController.getInstance().createToggleModelAndInit(slot),
          toggleStyle: PhoneStyleFactory.getInstance().createBasicStyle(),
          templateType: ToggleTemplateType.BASIC,
          toggleScene: ToggleScene.PHONE
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
        .focusable(false)
    }
    .width(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.singleCardWidth)
    .translate({ y: this.animationData.itemTranslate + Math.max(this.animationData.translate, 0) })
    .opacity(this.animationData.opacity)
    .scale({
      x: this.animationData.scale,
      y: this.animationData.scale
    })
  }
}