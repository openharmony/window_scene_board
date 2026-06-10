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

import { image } from '@kit.ImageKit';
import { SlCardChildId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { ComponentPosition, WidgetAnimStateV2, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { ImmersiveTypeScene } from '@ohos/systemuicommon';
import { ImmCardCheckData } from '../../model/data/v2/ImmCardCheckData';
import { ImmCardData } from '../../model/data/v2/ImmCardData';
import { ImmCardDataArray } from '../../model/data/v2/ImmCardDataArray';
import { SlCardBindStateV2 } from '../../model/data/v2/SlCardBindStateV2';
import { SlCardStaticStateV2 } from '../../model/data/v2/SlCardStaticStateV2';
import { CardShowType } from '../constants/ImmCardConst';
import { IImmCurDataCtrlVm } from './IImmCurDataCtrlVm';
import { IImmDataShareVm } from './IImmDataShareVm';
import { IImmersiveExtendVm } from './IImmersiveExtendVm';
import { IImmGestureEventVm } from './IImmGestureEventVm';
import { IImmLifeCycleVm } from './IImmLifeCycleVm';

/**
 * 沉浸大卡业务管理抽象层
 */
export interface IImmersiveCardVm extends IImmersiveExtendVm, IImmDataShareVm, IImmLifeCycleVm,
  IImmGestureEventVm, IImmCurDataCtrlVm {
  /**
   * 离屏截图初始化
   *
   * @param ctx UI环境
   * @param imgBuilder Image组件
   */
  initAstcSnapshot?(ctx: UIContext, imgBuilder: (param: image.PixelMap) => CustomBuilder): void;

  /**
   * 沉浸大卡列表数据
   *
   * @returns 列表数据
   */
  getSlCardData(): ImmCardDataArray;

  /**
   * 静态状态管理器
   *
   * @returns 静态状态管理器
   */
  getSlStaticState(): SlCardStaticStateV2;

  /**
   * UI绑定状态管理器
   *
   * @returns UI绑定状态管理器
   */
  getSlBindState(): SlCardBindStateV2;

  /**
   * 取用子动效状态
   *
   * @param childId 子动效ID
   * @returns 子动效状态
   */
  getChildAnimSt(childId: SlCardChildId): WidgetAnimStateV2 | undefined;

  /**
   * 取用子样式状态
   *
   * @param childId 子样式ID
   * @returns 子样式状态
   */
  getChildStyleSt(childId: SlCardChildId): WidgetStyleStateV2 | undefined;

  /**
   * 沉浸大卡位置切换
   *
   * @param oldValue 旧区域
   * @param newValue 新区域
   */
  onCardAreaChange(oldValue: Area, newValue: Area): void;

  /**
   * 实况卡片大小切换
   *
   * @param groupKey 分组标识
   * @param newValue 新大小
   */
  onLiveCardSizeChange?(groupKey: string, newValue: SizeOptions): void;

  /**
   * 取值大卡条目组件位置
   *
   * @param cardType 大卡类型
   * @returns 条目位置
   */
  getItemPosition(cardType: CardShowType): ComponentPosition | undefined;

  /**
   * 取用实况卡片组件位置
   *
   * @param groupKey 分组标识
   * @returns 实况卡片位置
   */
  getLiveCardPos?(groupKey?: string): ComponentPosition | undefined;

  /**
   * 取用实况卡片组件位置（卡片收拢/展开状态）
   *
   * @param groupKey 分组标识
   * @returns 实况卡片位置
   */
  getRealLiveCardPos?(groupKey?: string): ComponentPosition | undefined;

  /**
   * 取用实况列表测点击卡片位置
   *
   * @returns 点击卡片位置
   */
  getClickLiveCardPos?(): ComponentPosition | undefined;

  /**
   * 取用实况胶囊位置
   *
   * @returns 实况胶囊位置
   */
  getLiveCapPos?(): ComponentPosition | undefined;

  /**
   * 取值有效大卡数据
   *
   * @param groupKey 分组标识
   * @returns 大卡数据
   */
  getImmValidData(groupKey?: string): ImmCardData | undefined;

  /**
   * 沉浸大卡条目点击回调
   *
   * @param itemData 条目数据
   */
  onItemClick(itemData: ImmCardData): void;

  /**
   * 定位权限授权按钮点击回调
   *
   * @param itemData 条目数据
   */
  onAuthBtnClick(itemData: ImmCardData): void;

  /**
   * 沉浸大卡返回按钮点击回调
   *
   * @param itemData 条目数据
   */
  onBackBtnClick?(itemData: ImmCardData): void;

  /**
   * 实况卡片顶部箭头点击回调
   */
  onLiveArrowClick?(): void;

  /**
   * 动效检测大卡数据列表
   *
   * @returns 大卡数据
   */
  getCheckCardData(): ImmCardCheckData;

  /**
   * 检测当前是否满足沉浸大卡过渡列表动效
   *
   * @returns true 满足过渡动效
   */
  checkCardToListAnim(): boolean;

  /**
   * 请求记录胶囊大卡数据
   */
  requestCheckCapCard(): void;

  /**
   * 请求退出沉浸态
   *
   * @param isToCap 是否过渡到胶囊
   * @param scene 退出场景来源
   * @returns 是否正常退出
   */
  onExitImmState(isToCap?: boolean, scene?: ImmersiveTypeScene): boolean;

  /**
   * 实况列表过渡沉浸态
   *
   * @param groupKey 分组标识
   * @param scene 进入沉浸态场景标识
   */
  onLiveListToImmCard?(groupKey: string, scene?: ImmersiveTypeScene): void;

  /**
   * 实况卡片下滑手势回调
   */
  onLiveCardDownEvent?(): void;
}