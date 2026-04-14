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

// import fusionSearchClient from '@hms.ai.search';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'FusionSearchUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

const indexName: string = 'sysDesktopCard';
const size: number = 100;
const outFields: string[] = ['appName', 'appIndex', 'bundleName', 'cards', 'senderName', 'entityId'];
const queryFieldName: string[] = ['appName', 'displayName'];
const searchIndex: ESObject = { indexName: indexName, schemaType: 1 };
const cardFilter: ESObject = { field: 'appName', operator: 'ne', value: '0'};

// interface CardResultSchema extends fusionSearchClient.CommonSchema {
interface CardResultSchema {
  _globalScore: number;
  appIndex: number;
  appName: string;
  bundleName: string;
  cards: string;
  finalScore: number;
  indexName: string;
  senderName: string;
}

interface CardResultInfo {
  moduleName?: string,
  abilityName?: string,
  displayName?: string,
  cardName?: string,
}

export interface SingleAppResult {
  appName: string,
  // cardName --> displayName
  descriptionMap: Map<string, string>;
}

export class FusionSearchUtil {
  private searchSessionPromise?: Promise<ESObject>;

  public preConnect(): void {
    log.showInfo('Init');
    /*try {
      this.searchSessionPromise = fusionSearchClient.beginSearch([]);
    } catch (error) {
      log.showError(`BeginSearch error: ${error?.code}, ${error?.message}`);
    }*/
  }

  public destroy(): void {
    log.showInfo('Destroy');
    /*this.searchSessionPromise?.then((session) => {
      try {
        fusionSearchClient.endSearch(session);
      } catch (error) {
        log.error('EndSearch error', error);
      }
    });
    this.searchSessionPromise = undefined;*/
  }

  public async fusionSearch(searchString: string): Promise<Map<string, SingleAppResult>> {
    let resultMap: Map<string, SingleAppResult> = new Map();
    if (CheckEmptyUtils.checkStrIsEmpty(searchString)) {
      return resultMap;
    }

    let searchResult: CardResultSchema[] = await this.getSearchResult(searchString);
    searchResult.forEach((item: CardResultSchema) => {
      let bundleName: string = item.bundleName;
      let cardNameMap: Map<string, string> = new Map();
      let matchedCards: CardResultInfo[] = [];
      try {
        matchedCards = JSON.parse(item.cards) as CardResultInfo[];
      } catch (err) {
        log.showError(`parse result err: ${err?.code}`);
        return;
      }

      let cardNameMatchedMap: Map<string, string> = new Map();
      matchedCards.forEach((info: CardResultInfo) => {
        if (!info.cardName || !info.displayName) {
          return;
        }
        cardNameMap.set(info.cardName, info.displayName);
        if (info.displayName.includes('<em>')) {
          cardNameMatchedMap.set(info.cardName, info.displayName);
        }
      })
      log.showInfo(`search bundleName: ${bundleName}, matchedlen: ${cardNameMatchedMap.size}`);
      let singleAppResult: SingleAppResult = { appName: item.appName,
        descriptionMap: cardNameMatchedMap.size > 0 ? cardNameMatchedMap : cardNameMap };
      resultMap.set(bundleName, singleAppResult);
    })

    return resultMap;
  }

  private getSearchQuery(value: string): ESObject {
    let queryClause: ESObject = {
      query: value,
      searchFields: queryFieldName,
      queryType: 'match',
    }
    const query: ESObject = {
      index: searchIndex,
      outFields: outFields,
      filter: cardFilter,
      size: size,
      query: queryClause,
    }
    return query;
  }

  private async getSearchResult(value: string): Promise<CardResultSchema[]> {
    try {
      if (!this.searchSessionPromise) {
        log.showError('SearchSessionPromise is undefined.');
        return [];
      }
      const searchSession: ESObject = await this.searchSessionPromise;
      const query: ESObject = this.getSearchQuery(value);
      const result: ESObject = await searchSession.search(query);
      log.showDebug(`fusion search ${value}, result: ${JSON.stringify(result)}`);
      if (result?.records?.length) {
        return result.records;
      }
    } catch (error) {
      log.showError(`get search result failed, code: ${error?.code} , message: ${error?.message}`);
    }
    return [];
  }
}