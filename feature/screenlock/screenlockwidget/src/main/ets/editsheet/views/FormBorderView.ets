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

import { EDIT_FORM_DRAG } from '@ohos/screenlockcommon/src/main/ets/base/BaseViewModel';
import curves from '@ohos.curves';
import FormPlaceHolderInfo from '../../form/drag/FormPlaceHolderInfo';
import ScreenLockFormViewModel, { SupportFormLocation } from '../../form/vm/ScreenLockFormViewModel';
import { ColorType } from '../models/MainColor';
import FormBorderItem from './FormBorderItem';
import { clockLayoutHelper } from '../../clock/common/ClockLayoutHelper';
import { AnyClock } from '../models/AnyClock';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'FormBorderView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

class GridLayoutOptionRet {
  public static getGridLayoutOptions(formViewModel: ScreenLockFormViewModel,
    formHolders: FormPlaceHolderInfo[]): GridLayoutOptions {
    log.showInfo('GridLayoutOptionRet getGridLayoutOptions');
    return {
      onGetRectByIndex: (index: number): [number, number, number, number] => {
        let holder: FormPlaceHolderInfo | undefined = formHolders[index];
        if (!holder) {
          return [-1, 1, -1, 1];
        }
        let rect: [number, number, number, number] = GridLayoutOptionRet.getFormHolderRect(formViewModel, holder);
        log.showInfo(`onGetRectByIndex index: ${index}, rect: ${JSON.stringify(rect)}`);
        return rect;
      },
      // 大小规则的GridItem在Grid中占的行数和列数，只支持占1行1列即[1, 1]
      regularSize: [1, 1]
    };
  }

  private static getFormHolderRect(formViewModel: ScreenLockFormViewModel,
    holder: FormPlaceHolderInfo): [number, number, number, number] {
    if (formViewModel.isDoubleLineLayout()) {
      return [holder.positionY, holder.positionX - 1, 1, holder.dimensionX];
    } else {
      return [holder.positionY, holder.positionX, 1, holder.dimensionX];
    }
  }
}

@Component
export default struct FormBorderView {
  @Link @Watch('updateForms') formViewModel: ScreenLockFormViewModel;
  @Link clockStyle: AnyClock;
  @Prop @Watch('onDisplayModeChanged') displayMode: number;
  @Prop mainColorType: ColorType = ColorType.LIGHT;
  @Prop isLightWallpaper: boolean = true;
  @Prop gridWidth: number;
  @Prop formPositionY: number;

  @Consume holderInfo: FormPlaceHolderInfo;
  @State formHolders: FormPlaceHolderInfo[] = [];

  @State layoutOptions: GridLayoutOptions = GridLayoutOptionRet.getGridLayoutOptions(this.formViewModel,
    this.formHolders);

  aboutToAppear(): void {
    this.updateForms();
  }

  private onDisplayModeChanged(): void {
    if (this.displayMode === EDIT_FORM_DRAG) {
      this.formViewModel.handler?.registerDragCallback(() => this.updateForms());
    } else {
      this.formViewModel.handler?.unRegisterDragCallback();
    }
  }

  private updateForms(): void {
    this.formHolders = this.mergingData();
    if (this.holderInfo.dragForms) {
      this.formHolders.forEach((item) => {
        if (item.positionX === this.holderInfo.newX && item.positionY === this.holderInfo.newY) {
          item.isPlaceholder = true;
        }
      })
    }
    this.layoutOptions = GridLayoutOptionRet.getGridLayoutOptions(this.formViewModel, this.formHolders);
  }

  private mergingData(): FormPlaceHolderInfo[] {
    let forms: FormPlaceHolderInfo[] = [];
    this.formViewModel.supportFormPositions.forEach((item: SupportFormLocation) => {
      let form: FormPlaceHolderInfo = {
        positionX: item.positionX,
        positionY: item.positionY,
        dimensionX: 1,
        isForm: false
      }
      let existForm: FormPlaceHolderInfo | undefined = this.findInExistForm(form, this.formViewModel.formConfigs);
      if (existForm) {
        this.addExistForm(existForm, forms);
      } else {
        forms.push(form);
      }
    })
    return forms;
  }

  private findInExistForm(target: FormPlaceHolderInfo, forms: FormPlaceHolderInfo[]): FormPlaceHolderInfo | undefined {
    for (let i = 0; i < forms.length; i++) {
      if (target.positionY === forms[i].positionY &&
        target.positionX >= forms[i].positionX && target.positionX <= (forms[i].positionX + forms[i].dimensionX - 1)) {
        return {
          positionX: forms[i].positionX,
          positionY: forms[i].positionY,
          dimensionX: forms[i].dimensionX,
          isForm: true
        };
      }
    }
    return undefined;
  }

  private addExistForm(target: FormPlaceHolderInfo, holders: FormPlaceHolderInfo[]): void {
    let hasAdd: boolean = false;
    for (let index = 0; index < holders.length; index++) {
      if (target.positionX === holders[index].positionX && target.positionY === holders[index].positionY) {
        hasAdd = true;
        break;
      }
    }
    if (!hasAdd) {
      holders.push(target);
    }
  }

  build() {
    Grid(undefined, this.layoutOptions) {
      ForEach(this.formHolders, (item: FormPlaceHolderInfo) => {
        if (item.positionY < this.formPositionY) {
          GridItem() {
            FormBorderItem({
              displayMode: this.displayMode,
              formHolder: item,
              itemWidth: this.gridWidth * item.dimensionX - 12,
              itemHeight: this.gridWidth - 12,
              isLightWallpaper: this.isLightWallpaper,
              mainColorType: this.mainColorType
            })
          }
          .transition(TransitionEffect.OPACITY.animation({
            duration: 200,
            curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1)
          }).combine(TransitionEffect.scale({
            x: 0.8,
            y: 0.8,
          })))
          .width(this.gridWidth * item.dimensionX - 12)
          .height(this.gridWidth - 12)
        }
      }, (item: FormPlaceHolderInfo): string => {
        return JSON.stringify(item);
      })
    }
    .visibility(Visibility.Visible)
    .direction(Direction.Ltr)
    .columnsTemplate(this.formViewModel.isDoubleLineLayout() ? '1fr 1fr' : '1fr 1fr 1fr 1fr')
    .rowsTemplate(this.formViewModel.getFormPanelHeight() === 1 ? '1fr' : '1fr 1fr')
    .height(this.gridWidth * this.formViewModel.getFormPanelHeight())
    .width(this.gridWidth * (clockLayoutHelper.isN4Layout(this.clockStyle.layout) ? 4 : 2))
    .id(TAG)
  }
}