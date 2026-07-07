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

type LanguageInfo = Record<string, string | undefined>;

/**
 * 语音助手建议卡片多语言
 *
 * @since 2025-05-20
 */
export class MultiLanguages {
  /**
   * 场景名，如：“语音助手建议 | 驾驶”
   */
  public name?: LanguageInfo;

  /**
   * 场景提示语3描述，如："语音助手发现"
   */
  public desc?: LanguageInfo;

  /**
   * 场景提示语1描述，如："你在"
   */
  public desc1?: LanguageInfo;

  /**
   * 场景提示语2描述，如："驾驶模式中"
   */
  public desc2?: LanguageInfo;
}

