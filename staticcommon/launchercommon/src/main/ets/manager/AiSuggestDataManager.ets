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
import ArrayList from '@ohos.util.ArrayList';
import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';

const TAG = 'AiSuggestDataManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * form call back
 */
export interface AiSuggestionDataCallback {
  onUpdate: () => void;
}

export class AiSuggestDataManager {
  private static instance: AiSuggestDataManager;

  /**
   * form callbacks for ai suggestion Data. key:cardId
   */
  private formCallbackMap: Map<string, ArrayList<AiSuggestionDataCallback>> = new Map();

  /**
   * get AiSuggestionFormManager instance
   *
   * @return AiSuggestionFormManager instance
   */
  static getInstance(): AiSuggestDataManager {
    if (AiSuggestDataManager.instance == null) {
      AiSuggestDataManager.instance = new AiSuggestDataManager();
    }
    return AiSuggestDataManager.instance;
  }
  /**
   * register callback for form data
   *
   * @param cardId card id
   * @param callback form callback
   */
  registerCallback(cardId: string, callback: AiSuggestionDataCallback): void {
    log.showInfo('registerCallback: %{public}s', cardId);
    if (CheckEmptyUtils.checkStrIsEmpty(cardId)) {
      return;
    }
    let callbacks = this.formCallbackMap.get(cardId) ?? new ArrayList<AiSuggestionDataCallback>();
    callbacks.add(callback);
    this.formCallbackMap.set(cardId, callbacks);
  }

  /**
   * update AiSuggest Data and notify refresh component
   *
   * @param cardId card id
   */
  updateAiSuggestData(cardId: string): void {
    if (!CheckEmptyUtils.checkStrIsEmpty(cardId)) {
      log.showInfo('resetCard id undefined');
      return;
    }
    log.showInfo('resetCard id %{public}d', cardId);
    this.formCallbackMap.get(cardId)?.forEach(callback => callback.onUpdate());
  }

  /**
   * unregister callback by form id
   *
   * @param cardId card id
   * @param callback form callback
   */
  unRegisterCallback(cardId: string, callback: AiSuggestionDataCallback): void {
    log.showInfo('unRegisterCallback: %{public}s', cardId);
    let callbacks = this.formCallbackMap.get(cardId);
    callbacks?.remove(callback);
    if (callbacks?.isEmpty()) {
      log.showInfo('unRegisterCallback: formCallbackMap size %{public}d', this.formCallbackMap.size);
      this.formCallbackMap.delete(cardId);
    }
  }
}