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

import { fontScaleManager, FontScaleState } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { GestureDockItemInfo } from '../../../dockbar/model/GestureDockItemInfo';
import { AllAppsStyleConfig } from '../../model/AllAppsStyleConfig';
import { AllAppsStyleConfigMgr } from '../../model/AllAppsStyleConfigMgr';
import { image } from '@kit.ImageKit';
import { GestureDockMode } from '../../../common/GestureDockConstants';

/**
 * AllAppsParam
 */
@Observed
export class AllAppsParam {
  public recentAllApps: GestureDockItemInfo[] = [];
  public supportFloatWindowList: GestureDockItemInfo[] = [];
  public searchResultList: GestureDockItemInfo[] = [];
  public searchText: string = '';
  public allAppsStyleConfig: AllAppsStyleConfig = AllAppsStyleConfigMgr.getStyleConfig();
  public fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  public layoutOptions: GridLayoutOptions = {
    regularSize: [1, 1], // 只支持[1, 1]
    irregularIndexes: [0], // 索引为0和6的GridItem占用一行
  }
  public gestureDockShowMode: number = GestureDockMode.APPEAR;
  public isShowSearchResult: boolean = false;
  public searchBoxFocusable: boolean = false;
  public blurImage: image.PixelMap | undefined = undefined;
  public contentsHeight: number = 0;
  public padding: number = 0;
  public borderRadius: number = 0;
}