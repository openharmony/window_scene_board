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

import { LogDomain, LogHelper, ObjUtil } from '@ohos/basicutils';
import { ScreenLockStateManager } from '@ohos/screenlockcommon';
import { LockscreenFormConfig } from '../../common/WidgetParam';
import ScreenLockFormViewModel, { SupportFormLocation } from '../vm/ScreenLockFormViewModel';
import AbsDragHandler from './AbsDragHandler';
import FormPlaceHolderInfo from './FormPlaceHolderInfo';

const TAG = 'Layout2x2Handler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export default class Layout2x2Handler extends AbsDragHandler {
  constructor() {
    super();
    this.panelHeight = 2;
  }

  public handleDrag(formViewModel: ScreenLockFormViewModel, holderInfo: FormPlaceHolderInfo,
    supportPosition: SupportFormLocation[]): void {
    if (!ScreenLockStateManager.getInstance().isInEdite) {
      holderInfo.newX = 0;
      holderInfo.newY = 0;
      return;
    }
    if (!holderInfo.dragForms) {
      return;
    }
    log.showInfo(`newPosition = (${holderInfo.newX}, ${holderInfo.newY})`);

    // 查找交换的卡片
    let oldForm = formViewModel.formConfigs.find((item: LockscreenFormConfig) => {
      if (item.dimensionX === 2) {
        return (item.positionX + 1 === holderInfo.newX || item.positionX === holderInfo.newX) &&
          item.positionY === holderInfo.newY && item !== holderInfo.dragForms;
      }
      return item.positionX === holderInfo.newX && item.positionY === holderInfo.newY && item !== holderInfo.dragForms;
    })

    // 刷新被拖拽卡片位置
    this.handleUpdateDragItem(formViewModel, holderInfo, supportPosition);
    // 处理已有卡片的挤位
    if (holderInfo.dimensionX === 2) {
      this.handle1x2CardSqueeze(formViewModel, holderInfo, supportPosition);
    } else if (oldForm?.dimensionX === 2) {
      this.handleSqueeze1x2Card(formViewModel, oldForm, holderInfo, supportPosition);
    } else if (oldForm) {
      this.handleNormalSqueeze(formViewModel, oldForm, supportPosition);
    }

    this.onDrag();
  }

  private handleUpdateDragItem(formViewModel: ScreenLockFormViewModel, holderInfo: FormPlaceHolderInfo,
    supportPosition: SupportFormLocation[]): void {
    log.showInfo(`handleUpdateDragItem`);
    if (!holderInfo.dragForms || ObjUtil.isInvalid(holderInfo.newX) || ObjUtil.isInvalid(holderInfo.newY)) {
      return;
    }
    let positionX: number = holderInfo.newX === 1 ? 1 : 2;
    let positionY: number = holderInfo.newY === 0 ? 0 : 1;
    if (holderInfo.dimensionX === 2) {
      positionX = 1;
    }
    this.switchPosition(formViewModel, holderInfo.dragForms, positionX, positionY, supportPosition);
  }

  // 使用1x2的卡片挤占其它卡片的位置
  private handle1x2CardSqueeze(formViewModel: ScreenLockFormViewModel, holderInfo: FormPlaceHolderInfo,
    supportPosition: SupportFormLocation[]): void {
    log.showInfo(`handle1x2CardSqueeze`);
    if (!holderInfo.dragForms) {
      return;
    }
    let unUsedPositionX: number[] = [1, 2];// 另外一行未被使用的占位记录
    // 找到卡片里和当前卡片在一个Y坐标的卡片
    let forms: LockscreenFormConfig[] = formViewModel.formConfigs.filter((item: LockscreenFormConfig) => {
      if (item === holderInfo.dragForms) {
        return false;
      }
      if (item.positionY !== holderInfo.dragForms?.positionY) {
        unUsedPositionX.splice(item.positionX - 1, 1);
        return false;
      }
      return true;
    });
    // 把当前的卡片进行偏移
    forms.forEach((item: LockscreenFormConfig) => {
      // 当前是否存在1*2卡片进行挤位1*1卡片
      let isHandle1x2Card: boolean = false;
      if (holderInfo.newY === 0 && (holderInfo.newX === 1 || holderInfo.newX === 2)) {
        isHandle1x2Card = true;
      }
      let positionY: number = holderInfo.newY === 0 ? 1 : 0;
      let positionX: number = unUsedPositionX.indexOf(item.positionX) > -1 ? item.positionX : isHandle1x2Card ?
        unUsedPositionX[0] : unUsedPositionX[0] - 1;
      this.switchPosition(formViewModel, item, positionX, positionY, supportPosition);
    });
  }

  // 挤占1x2卡片的位置
  private handleSqueeze1x2Card(formViewModel: ScreenLockFormViewModel, oldForm: LockscreenFormConfig,
    holderInfo: FormPlaceHolderInfo, supportPosition: SupportFormLocation[]): void {
    log.showInfo(`handleSqueeze1x2Card`);
    let unUsedPositionX: number[] = [1, 2];// 另外一行未被使用的占位记录
    // 找到被挤占的1x2卡片另外一行的卡片的位置
    let forms: LockscreenFormConfig[] = formViewModel.formConfigs.filter((item: LockscreenFormConfig) => {
      if (item === holderInfo.dragForms) {
        unUsedPositionX.splice(item.positionX - 1, 1);
        return false;
      }
      if (item.positionY === oldForm.positionY) {
        return false;
      }
      return true;
    });
    // 把被挤占1x2卡片的对行卡片进行偏移
    forms.forEach((item: LockscreenFormConfig) => {
      let positionY: number = item.positionY === 0 ? 1 : 0;
      let positionX: number = unUsedPositionX.indexOf(item.positionX) > -1 ? item.positionX : unUsedPositionX[0];
      this.switchPosition(formViewModel, item, positionX, positionY, supportPosition);
    });
    // 把1x2卡片移动到对行
    let positionY: number = oldForm.positionY === 0 ? 1 : 0;
    let positionX: number = oldForm.positionX === 2 ? 1 : oldForm.positionX;
    this.switchPosition(formViewModel, oldForm, positionX, positionY, supportPosition);
  }

  // 使用1x1卡片挤占1x1卡片的位置
  private handleNormalSqueeze(formViewModel: ScreenLockFormViewModel, oldForm: LockscreenFormConfig,
    supportPosition: SupportFormLocation[]): void {
    // 卡片放到下一个没有被占用的位置,找到第一个可用位置Break
    log.showInfo(`handleNormalSqueeze`);
    for (let i = 0; i < supportPosition.length; i++) {
      const item = supportPosition[i];
      if (item.isShow && item.positionY < formViewModel.getFormPanelGridLimit()) {
        this.switchPosition(formViewModel, oldForm, item.positionX, item.positionY, supportPosition);
        break;
      }
    }
  }
}