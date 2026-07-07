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
import { AiSuggestionConstants } from './AiSuggestionConstants';

/**
 * 语音助手建议工具类
 *
 * @since 2025-05-17
 */
export class AiSuggestionUtil {
  public static isVoiceAbilityForm(bundleName: string, abilityName: string): boolean {
    return bundleName === AiSuggestionConstants.AI_SUGGESTION_BUNDLE_NAME &&
      abilityName === AiSuggestionConstants.AI_SUGGESTION_ABILITY_NAME;
  }
}