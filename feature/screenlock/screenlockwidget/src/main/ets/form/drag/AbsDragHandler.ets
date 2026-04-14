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

import { LockscreenFormConfig } from '../../common/WidgetParam';
import ScreenLockFormViewModel, { SupportFormLocation } from '../vm/ScreenLockFormViewModel';
import FormPlaceHolderInfo from './FormPlaceHolderInfo';

export default abstract class AbsDragHandler {
  protected onDrag: Callback<void> = () => {};

  protected panelHeight: number = 0;

  public abstract handleDrag(formViewModel: ScreenLockFormViewModel, holderInfo: FormPlaceHolderInfo,
    supportPosition: SupportFormLocation[]): void;

  public registerDragCallback(callback: Callback<void>): void {
    this.onDrag = callback;
  }

  public unRegisterDragCallback(): void {
    this.onDrag = () => {};
  }

  protected switchPosition(formViewModel: ScreenLockFormViewModel, target: LockscreenFormConfig,
    positionX: number, positionY: number, supportPosition: SupportFormLocation[]) {
    target.positionX = positionX;
    target.positionY = positionY;
    formViewModel.formConfigs =
      formViewModel.formConfigs.filter((item: LockscreenFormConfig) => item.dimensionX !== 0);
    // 刷新卡片位置占用标记位
    this.updatePositionFormShowState(formViewModel, supportPosition);
  }

  private updatePositionFormShowState(formViewModel: ScreenLockFormViewModel, supportPosition: SupportFormLocation[]) {
    supportPosition.forEach((item: SupportFormLocation) => {
      let index: number = formViewModel.formConfigs.findIndex((form: LockscreenFormConfig) => {
        if (form.dimensionX === 2) {
          return (form.positionX === item.positionX || form.positionX + 1 === item.positionX) &&
            item.positionY === form.positionY;
        }
        return form.dimensionX > 0 && form.positionX === item.positionX && form.positionY === item.positionY;
      });
      item.isShow = index < 0;
    })
  }
}