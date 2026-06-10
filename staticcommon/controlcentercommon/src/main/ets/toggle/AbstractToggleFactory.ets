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
import { ToggleStyle } from './interface/ToggleStyle'

export interface AbstractToggleStyleFactory {

  // 创建基础开关，通常为图标加标题的形式
  createBasicStyle?: () => ToggleStyle | undefined;

  // 创建带附加内容的开关，例如显示wifi名称的wifi开关
  createTaggedStyle?: () => ToggleStyle | undefined;
}

export class DefaultStyleFactory implements AbstractToggleStyleFactory {

}
