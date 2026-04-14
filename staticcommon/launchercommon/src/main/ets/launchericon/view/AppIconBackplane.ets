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

import { AppIconBackplaneVm } from '../viewmodel/AppIconBackplaneVm'
import { editModeManager } from '../../editmode/model/EditModeManager';
import { EditModeViewState } from '../../editmode/data/EditModeViewState';
import { EditModeFolderViewData } from '../../editmode/data/EditModeFolderViewData';
import { AttributeUpdater } from '@ohos.arkui.modifier';

const RADIUS_SCALE = 1.15;

export class AppIconBackplaneModifier extends AttributeUpdater<CommonAttribute> {
  public onInit?: (instance: CommonAttribute) => void;

  initializeModifier(instance: CommonAttribute): void {
    this.onInit?.(instance);
  }
}

@Component
export struct AppIconBackplane {
  appIconId: string = '';
  backplaneSize: number = 0;
  backplaneRadius: number = 0;
  @Link backplaneVm: AppIconBackplaneVm;
  @State editModeViewState: EditModeViewState = editModeManager.getEditModeViewState();
  @State editModeFolderViewData: EditModeFolderViewData = editModeManager.getEditModeFolderViewData();

  build() {
    if (this.backplaneVm.visible) {
      Column()
      .attributeModifier(this.backplaneVm.modifier)
      .width(this.backplaneSize)
      .height(this.backplaneSize)
      .borderRadius(this.backplaneRadius * RADIUS_SCALE)
      .useEffect(this.backplaneVm.useEffect)
      .scale({ x: this.backplaneVm.scale, y: this.backplaneVm.scale })
      .alignRules({
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        top: { anchor: '__container__', align: VerticalAlign.Top },
      })
      .id(`${this.appIconId}_AppIconBackplane`)
      if (this.editModeViewState.isShowEditModeView()) {
        Column() {
        }
        .width(this.backplaneSize)
        .height(this.backplaneSize)
        .borderRadius(this.backplaneRadius * RADIUS_SCALE)
        .backgroundColor(this.editModeFolderViewData.getFolderBackgroundColor())
        .scale({ x: this.backplaneVm.scale, y: this.backplaneVm.scale })
        .alignRules({
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
          top: { anchor: '__container__', align: VerticalAlign.Top },
        })
      }
    }
  }
}