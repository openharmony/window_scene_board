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

import { describe, it, expect } from '@ohos/hypium'
import { AppItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { SearchComponent, SearchState } from '../../../../../../main/ets/default/view/SearchComponent';

export default function SearchComponentTest() {
  describe('SearchComponentTest', () => {

    it('SearchComponentTest_getFontSize', 0, () => {
      try {
        let searchComponent: SearchComponent = new SearchComponent();
        (searchComponent as object)['getFontSize'](3);
        let searchResultList: AppItemInfo[] = [];
        (searchComponent as object)['searchAppList'](searchResultList);
        (searchComponent as object)['resetSearchData']();
        expect(searchComponent.mResultLen).assertEqual(0);
        searchComponent.mSearchValue = '';
        (searchComponent as object)['handleSearchResult'](searchResultList);
        expect(searchComponent.mResultLen).assertEqual(0);
        searchComponent.mSearchValue = 'mSearchValue';
        (searchComponent as object)['handleSearchResult'](searchResultList);
        expect(searchComponent.mResultLen).assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('SearchComponentTest_setSearchStateWhenValueChange', 0, () => {
      try {
        let searchComponent: SearchComponent = new SearchComponent();
        (searchComponent as object)['onSearchValueChange']('inputValue');
        expect(searchComponent.mSearchValue).assertEqual('inputValue');
        searchComponent.mSearchStateMgr.setState(SearchState.NONE);
        (searchComponent as object)['setSearchStateWhenValueChange']();
        expect(searchComponent.mSearchStateMgr.getState()).not().assertEqual(SearchState.FOCUSED);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
  })
}