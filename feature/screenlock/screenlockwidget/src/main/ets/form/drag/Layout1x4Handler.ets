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
import { LockscreenFormConfig } from '../../common/WidgetParam';
import ScreenLockFormViewModel, { SupportFormLocation } from '../vm/ScreenLockFormViewModel';
import AbsDragHandler from './AbsDragHandler';
import FormPlaceHolderInfo from './FormPlaceHolderInfo';

const TAG = 'Layout1x4Handler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export default class Layout1x4Handler extends AbsDragHandler {
  constructor() {
    super();
    this.panelHeight = 1;
  }

  public handleDrag(formViewModel: ScreenLockFormViewModel, holderInfo: FormPlaceHolderInfo,
    supportPosition: SupportFormLocation[]): void {
    if (!holderInfo.dragForms || ObjUtil.isInvalid(holderInfo.newX) || ObjUtil.isInvalid(holderInfo.newY)) {
      return;
    }

    log.showInfo(`newPosition = (${holderInfo.newX}, ${holderInfo.newY})`);
    // 初始化map用于保存占用情况数据
    let formMap: Map<number, LockscreenFormConfig> = new Map();
    formViewModel.formConfigs.forEach((item: LockscreenFormConfig) => {
      if (item !== holderInfo.dragForms && item.dimensionX !== 0) {
        this.setForm(formMap, item.positionX, item);
      }
    });

    // 生成一个新的队列，将添加卡片到目标位置占位的卡片保存到队列中，新卡片放置到目标位置
    let formQueue: LockscreenFormConfig[] = this.putDragForm(formMap, holderInfo);

    while (formQueue.length > 0) {
      let form: LockscreenFormConfig | undefined = formQueue.pop();
      if (!form) {
        continue;
      }
      // 按空位放置被挤占位置的卡片
      this.setForm(formMap, this.getPlace(formMap, form.dimensionX), form);
    }

    // 整体进行一轮卡片的位移
    formMap.forEach((item: LockscreenFormConfig, key: number) => {
      if (key < 4) {
        this.switchPosition(formViewModel, item, key, 0, supportPosition);
      }
    });
    this.onDrag();
  }

  private putDragForm(formMap: Map<number, LockscreenFormConfig>,
    holderInfo: FormPlaceHolderInfo): LockscreenFormConfig[] {
    let formQueue: LockscreenFormConfig[] = [];
    if (!holderInfo.dragForms || holderInfo.newX === undefined) {
      return formQueue;
    }
    for (let i = 0; i < holderInfo.dimensionX; i++) {
      // 获取目标位置是否有占用的卡片
      let form: LockscreenFormConfig | undefined = formMap.get(holderInfo.newX + i);
      if (form) {
        // 有占用，将占位的卡片添加到队列，原有记录里移除占位的卡片
        formQueue.push(form);
        formMap.delete(holderInfo.newX + i);
        formMap.delete(holderInfo.newX + i + 5);
        continue;
      }
      // 获取目标位置是否被一个dimension为2的卡片额外占用
      form = formMap.get(holderInfo.newX + i + 4);
      if (form) {
        // 有占用，将占位的卡片添加到队列，原有记录里移除占位的卡片
        formQueue.push(form);
        formMap.delete(holderInfo.newX + i + 4);
        formMap.delete(holderInfo.newX + i - 1);
      }
    }
    // 队列中有一个被从原有记录移除的占位卡片，且卡片dimension为2
    if (formQueue.length === 1 && formQueue[0].dimensionX === 2) {
      // 新添加的卡片dimension是2
      if (holderInfo.dimensionX === 2) {
        // 原有卡片的位置在最开始的位置，则把新卡片设置到最开始的位置，否则放在靠后的两个位置
        this.setForm(formMap, formQueue[0].positionX === 0 ? 0 : 2, holderInfo.dragForms);
      } else {
        // 把剩余的卡片全部按顺序添加到队列中
        formMap.forEach((item: LockscreenFormConfig) => {
          formQueue.push(item);
        });
        formMap.clear();
        // 将新添加的卡片放到目标位置
        formMap.set(holderInfo.newX, holderInfo.dragForms);
      }
    } else {
      // 直接把新添加的卡片放到目标位置
      this.setForm(formMap, holderInfo.newX, holderInfo.dragForms);
    }
    // 把队列进行排序
    formQueue.sort((a: LockscreenFormConfig, b: LockscreenFormConfig) => {
      return a.dimensionX - b.dimensionX;
    });
    return formQueue;
  }

  private getPlace(map: Map<number, LockscreenFormConfig>, dimensionX: number): number {
    let index: number = -1;
    for (let i = 0; i < 4; i++) {
      let canPlace: boolean = true;
      for (let j = 0; j < dimensionX; j++) {
        if (map.has(i + j) || map.has(i + j + 4)) {
          canPlace = false;
        }
      }
      if (canPlace) {
        return i;
      }
    }
    return index;
  }

  private setForm(map: Map<number, LockscreenFormConfig>, key: number, value: LockscreenFormConfig): void {
    map.set(key, value);
    // 卡片长度为2,key + 1会被占用，+5是为了区分是否为卡片，key % 4为实际位置
    if (value.dimensionX === 2) {
      map.set(key + 5, value);
    }
  }
}