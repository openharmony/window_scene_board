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
/**
 * 此类仅允许添加开关业务过程中会影响UI刷新的变量，不影响UI刷新的变量请添加至./interface/ToggleStyle.ets文件
 */
@Observed
export class ToggleViewData {
  /**
   * 控制开关开启状态的显示
   */
  @Track public isOn: boolean = false;

  /**
   * 控制开关图标的显示
   */
  @Track public icon?: Resource;

  /**
   * 控制开关标签的显示
   */
  @Track public label?: string | Resource;

  /**
   * 1*2双行不同文本开关辅助标签的显示
   */
  @Track public subLabel?: string | Resource;

  /**
   * 控制开关可用状态的显示
   */
  @Track public isUnavailable: boolean = false;

  /**
   * 用来控制symbol图标动效的启停
   * 由于底层框架的不统一，有些symbol动效的启停依赖isSymbolActive，
   * 有些依赖symbolTriggerValue，请根据实际使用的动效来选择控制变量
   */
  @Track public isSymbolActive: boolean = false;

  /**
   * 用来控制symbol图标动效的启停
   * 由于底层框架的不统一，有些symbol动效的启停依赖isSymbolActive，
   * 有些依赖symbolTriggerValue，请根据实际使用的动效来选择控制变量
   */
  @Track public symbolTriggerValue: number = -1;

  /**
   * 用来动态切换开关图标格式为symbol还是image
   */
  @Track public isSymbolIcon: boolean = false;

  /**
   * 动态控制开关图标圆形背板的显示或者隐藏
   */
  @Track public hideIconBackground: boolean = false;
}