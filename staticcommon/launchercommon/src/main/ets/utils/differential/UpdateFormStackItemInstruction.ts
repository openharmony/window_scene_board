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
import type GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { Instruction } from './Instruction';
import { CommonConstants } from '../../constants/CommonConstants';
import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';

const TAG = 'UpdateFormStackItemInstruction';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class UpdateFormStackItemInstruction extends Instruction {
  /**
   * 构造器
   *
   * @param rows 屏幕的最大行数
   * @param columns 屏幕的最大列数
   */
  public constructor(rows: number, columns: number) {
    super(rows, columns);
  }

  protected realize(gridInfo: GridLayoutItemInfo[], item: GridLayoutItemInfo): GridLayoutItemInfo[] {
    if (CheckEmptyUtils.isEmpty(gridInfo) || CheckEmptyUtils.isEmpty(item)) {
      log.showError('UpdateFormStackItemInstruction gridInfo is empty or item is empty');
      return gridInfo;
    }

    // 传入的formStackId匹配不上
    const index: number = gridInfo.findIndex(dataItem => dataItem.formStackId === item.formStackId);
    if (index === CommonConstants.INVALID_VALUE) {
      log.showError(`The formStack to be update does not exist. Please check formStackId:${item.formStackId}`);
      return gridInfo;
    }
    let gridInfoItem = gridInfo[index];
    if (CheckEmptyUtils.isEmpty(gridInfoItem)) {
      log.error('gridInfo item is empty');
      return gridInfo;
    }
    if (CheckEmptyUtils.isEmptyArr(gridInfoItem.layoutInfo)) {
      log.error('gridInfoItem.layoutInfo is null or empty');
      return gridInfo;
    }
    let mLayoutInfo = gridInfo[index].layoutInfo;
    if (!mLayoutInfo) {
      return gridInfo;
    }
    let formStackItemList: GridLayoutItemInfo[] = mLayoutInfo[0];
    let newForms: GridLayoutItemInfo[] | undefined = item.layoutInfo?.[0];
    if (!newForms || CheckEmptyUtils.isEmptyArr(newForms)) {
      log.showError(`The newForms to update is empty`);
      return gridInfo;
    }
    log.showInfo(`formStackItemList:${formStackItemList.length}, newForms:${newForms.length}`);

    // 传入的卡片列表不合规
    if (!this.isNewFormsValid(newForms, formStackItemList)) {
      return gridInfo;
    }

    // 正式替换
    let newFormStackItemList: GridLayoutItemInfo[] = this.replaceFormStackItem(newForms, formStackItemList);

    // 不允许替换之后的卡片列表中bundleName相同，bundleName不相同才能赋值给gridInfo
    if (!this.hasDuplicateBundleName(newFormStackItemList)) {
      mLayoutInfo[0] = newFormStackItemList;
    }
    log.showInfo(`finally merged formStackItemList:${mLayoutInfo[0].length}`);
    return gridInfo;
  }

  private isNewFormsValid(newForms: GridLayoutItemInfo[], formStackItemList: GridLayoutItemInfo[]): boolean {
    // 传入的卡片数量大于4不处理，等于0不用处理
    if (newForms.length > 4 || newForms.length === 0) {
      log.showError(`Newforms number must be more than 0 and less than 5. There is:${newForms.length}`);
      return false;
    }

    // 有透明卡片的时候指令不生效
    let transparentForm: GridLayoutItemInfo | undefined = newForms.find(newForm => newForm.isTransparent);
    if (transparentForm) {
      log.showError(`transparent form is not allowed: ${transparentForm.bundleName}`);
      return false;
    }

    // 传入的卡片cardDimension不对
    let invalidDimensionForm: GridLayoutItemInfo | undefined = newForms.find(
      newForm => newForm.cardDimension !== formStackItemList[0].cardDimension);
    if (invalidDimensionForm) {
      log.showError(`newForm cardDimension is not match, bundleName: ${invalidDimensionForm.bundleName}, invalidDimension:${invalidDimensionForm.cardDimension}`);
      return false;
    }
    return true;
  }

  private replaceFormStackItem(newForms: GridLayoutItemInfo[], formStackItemList: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    // 正式替换，传入数量小于初始数量时好替换，一对一替换。
    // 等于或者大于初始数量时，除了top张，其他全部使用传入的卡片
    if (formStackItemList.length <= newForms.length) {
      newForms.push(formStackItemList[formStackItemList.length - 1]);
    } else {
      for (let i = newForms.length; i < formStackItemList.length; i++) {
        newForms.push(formStackItemList[i]);
      }
    }
    log.showInfo(`newFormStackItemList.length: ${newForms.length}`);
    return newForms;
  }


  private hasDuplicateBundleName(list: GridLayoutItemInfo[]): boolean {
    let bundleNameList: Set<string> = new Set();
    for (let i = 0; i < list.length; i++) {
      let bundleName: string = list[i].bundleName;
      if (bundleNameList.has(bundleName)) {
        log.showError(`formStackItemList bundleName:${bundleName} is not allowed to be duplicated`);
        return true;
      }
      bundleNameList.add(bundleName);
    }
    return false;
  }
}

