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

import { SlStateBaseMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { ImmInvertColorMgr, ImmRunningLockMgr } from '@ohos/screenlockcommon/Index';
import { ImmersiveNtfData } from './ImmersiveNtfData';
import { IUiExtensionDataArr } from '../../model/interface/IUiExtensionDataArr';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ImmersiveConstants } from '@ohos/systemuicommon';

const TAG = 'ImmersiveCardList';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

// 大卡数据类型
export enum CardListType {
  TYPE_MAIN = 'mainData',
  TYPE_TEMP = 'tempData',
}

@Observed
export class UiExtensionDataArr extends Array<ImmersiveNtfData> {
}

/**
 * 沉浸卡片列表
 */
@Observed
export class ImmersiveCardList implements IUiExtensionDataArr {
  // 数据类型
  private readonly listType: CardListType;

  /**
   * 沉浸数据
   */
  private _showData?: ImmersiveNtfData;

  /**
   * 动效卡片数据
   */
  private _animShowData?: ImmersiveNtfData;
  
  /**
   * uiExtension数据集
   */
  private readonly _uiExtensionDataArr: UiExtensionDataArr = new UiExtensionDataArr();

  constructor(listType: CardListType = CardListType.TYPE_MAIN) {
    this.listType = listType;
  }
  /**
   * 获取uiExtension数据集
   */
  public getUiExtensionDataArr(): UiExtensionDataArr {
    return this._uiExtensionDataArr;
  }

  /**
   * 添加uiExtension数据
   *
   * @param data uiExtension数据
   */
  public addUiExtensionData(data?: ImmersiveNtfData): void {
    if (!data) {
      return;
    }
    let index = this._uiExtensionDataArr.findIndex((child) => child.hashCode === data?.hashCode);
    if (index >= 0) {
      this._uiExtensionDataArr.splice(index, 1, data);
    } else {
      // 目前uiExtension沉浸卡片最多缓存3个
      if (this._uiExtensionDataArr.length >= 3) {
        this._uiExtensionDataArr.shift();
      }
      this._uiExtensionDataArr.push(data);
    }
    log.showWarn(`addUiExtensionData hashCode:${data?.hashCode} _uiExtensionDataArrlength:${this._uiExtensionDataArr.length}`);
  }

  /**
   * 移除uiExtension数据
   *
   * @param data uiExtension数据
   */
  public removeUiExtensionData(data: ImmersiveNtfData): void {
    let findIndex = this._uiExtensionDataArr.findIndex((child) => child.hashCode === data?.hashCode);
    if (findIndex === -1) {
      return;
    }
    this._uiExtensionDataArr.splice(findIndex, 1);
  }

  /**
   * 清除uiExtension数据
   *
   * @param data uiExtension数据
   */
  public clearUiExtensionData(): void {
    let length: number = this._uiExtensionDataArr.length;
    if (this._uiExtensionDataArr) {
      log.showWarn(`clearUiExtensionData start`);
      this._uiExtensionDataArr.splice(0, length);
    }
  }

  /**
   * 设置显示沉浸数据
   *
   * @param showData 数据
   */
  public setShowData(showData?: ImmersiveNtfData): void {
    if (SlStateBaseMgr.isV2Enable()) {
      return;
    }
    if (this._showData !== showData) {
      this._showData = showData;
      // 标识当前显示大卡数据
      if (this.isMainData()) {
        ImmInvertColorMgr.getInstance().setCurShowingImmersive(showData?.hashCode);
        ImmRunningLockMgr.getInstance().setCurShowingImmersive(showData?.hashCode);
        if (showData && showData?.isUiExtensionCard()) {
          this.addUiExtensionData(showData);
        }
      }
    }
  }

  /**
   * 设置动效沉浸数据
   *
   * @param animData 数据
   */
  public setAnimData(animData?: ImmersiveNtfData): void {
    if (this._animShowData !== animData) {
      this._animShowData = animData;
    }
  }

  /**
   * 显示大卡数据
   *
   * @returns 数据
   */
  public get showData(): ImmersiveNtfData | undefined {
    return this._showData;
  }

  /**
   * 动效大卡数据
   *
   * @returns 数据
   */
  public get animShowData(): ImmersiveNtfData | undefined {
    return this._animShowData;
  }

  /**
   * 主数据类型
   *
   * @returns true主数据
   */
  public isMainData(): boolean {
    return this.listType === CardListType.TYPE_MAIN;
  }

  /**
   * 是否是缓存卡片
   *
   * @returns true 是缓存卡片
   */
  public isUiExtensionCache(data: ImmersiveNtfData): boolean {
    let findIndex = this._uiExtensionDataArr.findIndex((child) => child.hashCode === data.hashCode);
    if (findIndex !== -1) {
      log.showWarn(`hashCode:${data?.hashCode} isUiExtensionCache`);
      return true;
    }
    return false;
  }
}

// 沉浸数据，保持单例
export const cardList: ImmersiveCardList = new ImmersiveCardList();