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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { CardItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FormCommonUtil } from '@ohos/launchercommon/src/main/ets/TsIndex';
import ScreenLockFormViewModel from './vm/ScreenLockFormViewModel';
const TAG = 'ScreenLockFormDetailItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const SINGLE_COLOR_RENDER_MODE:number = 1;

@Component
export default struct ScreenLockFormDetailItem {
  private formItem: CardItemInfo = new CardItemInfo();
  private formItemWidth: number = 0;
  private formItemHeight: number = 0;
  private dimension: FormDimension = FormDimension.Dimension_1_2;
  private allowUpdate: boolean = true;
  private getFormId: Function = (id: number): void => {};
  private formRadius: number = ResUtils.getNumber($r('app.float.form_corner_radius'));

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.formRadius = this.formItemHeight / 2
  }

  aboutToDisappear(): void {
    log.showInfo('disappear');
  }

  build() {
    Stack() {
      Column()
        .backgroundColor('#000000')
        .opacity(0.3)
        .borderRadius(this.formRadius)
        .width(this.formItemWidth)
        .height(this.formItemHeight)
      FormComponent({
        id: FormCommonUtil.transformCardId(this.formItem.cardId),
        name: this.formItem.cardName as string,
        bundle: this.formItem.bundleName as string,
        ability: this.formItem.abilityName as string,
        module: this.formItem.moduleName as string,
        dimension: this.dimension,
        renderingMode: SINGLE_COLOR_RENDER_MODE,
        want: ScreenLockFormViewModel.getFromWant(),
      })
        .id(`${TAG}_FormComponent`)
        .hoverEffect(HoverEffect.None)
        .hitTestBehavior(HitTestMode.None)
        .borderRadius(this.formItemHeight / 2 - 8)
        .size({
          width: this.formItemWidth - 16,
          height: this.formItemHeight - 16
        })
        .padding({
          top: 8, bottom: 8, left: 8, right: 8
        })
        .allowUpdate(this.allowUpdate)
        .onAcquired((form: FormCallbackInfo) => {
          log.showDebug(`FormComponent card id is: ${form.idString}`);
          this.formItem.cardId = String(form.idString);
          if (this.getFormId) {
            this.getFormId(form.idString);
          }
        })
        .onError((error) => {
          log.showError(`FormComponent error msg: ${error.msg}`);
        })
    }
  }
}