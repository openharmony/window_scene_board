/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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

import { GridLayoutItemInfo } from '@ohos/launchercommon';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import { PageDesktopViewModel } from '../../viewmodel/PageDesktopViewModel';
import DesktopItem from '../DesktopItem';
import { DeskTopItemStyle } from '@ohos/launchercommon/Index';
import { StyleConstants } from '@ohos/launchercommon';

const TAG = 'FolderChangeComponent';

@Component
export default struct FolderChangeComponent {
  @State item: GridLayoutItemInfo = new GridLayoutItemInfo();
  private mPageDesktopViewModel?: PageDesktopViewModel;
  private mNameLines: number = 0;
  private mMaxNameLines: number = 0;
  private isPad: boolean = false;
  private mPageDesktopStyleConfig?: PageDesktopGridStyleConfig;
  @State iconSize: number = StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH;
  @State selectedStatus: boolean = false;

  build(){
    Column() {
      DesktopItem({
        item: this.item,
        mPageDesktopViewModel: this.mPageDesktopViewModel,
        mNameLines: this.mNameLines,
        mMaxNameLines: this.mMaxNameLines,
        isPad: this.isPad,
        iconSize: this.iconSize,
        mPageDesktopStyleConfig: this.mPageDesktopStyleConfig,
        isFolderChange: true,
        desktopStyle: new DeskTopItemStyle(0, 0, 1, 1, false),
        selectedStatus: this.selectedStatus
      })
        .id(`${TAG}_FolderChangeItem`)
    }
  }
}