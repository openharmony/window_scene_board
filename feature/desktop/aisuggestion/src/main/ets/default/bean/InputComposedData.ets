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
import type { InputComposedAbilities } from './InputComposedAbilities';
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { PortfolioInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/PortfolioInfo';

/**
 * 语音助手建议推荐的内容
 *
 * @since 2023-10-08
 */
export class InputComposedData {
  // 服务推荐ID
  public recId: string = '';

  // 一次服务推荐ID下的子ID，如局部替换后的半流程推荐
  public subRecId: number = 0;

  // 0：更新，1：添加，2：删除，3：更新且轮转，4：添加且轮转
  public optType: number = 0;

  // 竖屏下的卡片组合信息
  public portrait?: InputComposedAbilities;

  // 横屏下的卡片组合信息
  public landscape?: InputComposedAbilities;

  // 折叠屏展开情况下卡片展示信息
  public expand?: InputComposedAbilities;

  // 堆叠轮转的卡片组合信息
  public recommendCard?: InputComposedAbilities;

  // 场景卡相关的信息
  public portfolioInfo?: PortfolioInfo;

  /**
   * 堆叠内语音助手建议卡片唯一标识，用于桌面对ADD和UPDATE命令的过滤
   *
   * 场景示例：
   * 1、堆叠中已有晨间场景卡，如果接收到ADD晨间场景卡的命令，则会丢弃该命令。
   * 2、堆叠中已有晨间场景卡，如果接收到某卡片UPDATE成为晨间场景卡的命令，则会丢弃该命令。
   */
  public cardUniqueTag: string = '';

  // 堆叠ID，undefined或null时代表更新卡片或者创建堆叠场景
  public stackId: string = '';

  // 语音助手建议特性支持版本
  public featureVersion: number = 0;

  /**
   * 判断命令是否需要刷新内容
   *
   * @param data 刷新内容
   * @returns optType是否有刷新内容
   */
  public static isNeedUpdateContent(data: InputComposedData): boolean {
    if (!data) {
      return false;
    }
    return data.optType === AiSuggestionUpdateConstants.OptType.UPDATE_CARD ||
      data.optType === AiSuggestionUpdateConstants.OptType.ADD_CARD ||
      data.optType === AiSuggestionUpdateConstants.OptType.UPDATE_AND_SWITCH ||
      data.optType === AiSuggestionUpdateConstants.OptType.ADD_AND_SWITCH;
  }
}