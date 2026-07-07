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
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { SheetModel } from '../model/SheetModel';

const TAG = 'BaseBindSheet_Component';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

@Component
export struct BaseBindSheet {
  @BuilderParam child: () => void;
  @Prop isShowPanel: boolean = true;
  @Prop isShowClose: boolean = true;
  @State sheetModel: SheetModel = SheetModel.get();
  // bindsheet展开的钩子函数
  onPanelAppear: () => void = () => {
  }
  // bindsheet关闭的钩子函数
  onPanelDisAppear: () => void = () => {
  }
  // bindsheet将要关闭的钩子函数
  onPanelWillDisAppear: () => void = () => {
  }

  aboutToAppear() {
    this.sheetModel.calcHeight()
    log.showInfo(`AboutToAppear.`);
  }

  aboutToDisappear(): void {
    log.showInfo('AboutToDisappear.');
  }

  build() {
    Column() {
    }
    .bindSheet($$this.isShowPanel, this.contentBuilder(), this.getBindSheetConfig())
  }

  @Builder contentBuilder() {
    Column() {
      this.child()
    }
  }

  private getBindSheetConfig(): SheetOptions {
    const sheetConfig = {
      height: this.sheetModel.height,
      dragBar: false,
      showClose: this.isShowClose,
      backgroundColor: $r('sys.color.ohos_id_color_panel_bg'),
      maskColor: $r('sys.color.ohos_id_color_mask_thin'),
      preferType: SheetType.CENTER,
      onAppear: () => {
        log.showInfo('enter bindSheet onAppear');
        this.onPanelAppear();
      },
      onDisappear: () => {
        this.onPanelDisAppear();
        log.showInfo('enter bindSheet disappear');
      },
      onWillDisappear: () => {
        this.onPanelWillDisAppear();
        log.showInfo('enter bindSheet will disappear');
      }
    } as SheetOptions;
    return sheetConfig;
  }
}