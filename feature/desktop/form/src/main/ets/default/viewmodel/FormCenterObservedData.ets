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
import GridRowManager from '../manager/GridRowManager';

@Observed
export class AppFormItemData {
  public animateScale: number = 1;
  public offset: number = 0;
}

@Observed
export class RecommendFormItemData {
  public animateScale: number = 1;
}

@Observed
export class NavDestinationViewData {
  public column: number = 0;
  public bindSheetWidth: number = 0;
  public bindSheetHeight: number = 0;
  public viewWidth: number = 0;
  public viewHeight: number = 0;
  public addFormButtonWidth: number = 0;
  public formViewHeight: number = 0;
  public cardViewMargin: number = 0;
  public formRate: number = 0;
}

@Observed
export class ViewData {
  public bindSheetWidth: number = 0;
  public bindSheetHeight: number = 0;
  public bindSheetColumns: number = 0;
  public margin: number = 0;
  public appListWidth: number = 0;
  public navDestinationViewData: NavDestinationViewData = new NavDestinationViewData();
  public isAddToNegativeScreen: boolean = false;
  public isAsdeOpen: boolean = false;
}
