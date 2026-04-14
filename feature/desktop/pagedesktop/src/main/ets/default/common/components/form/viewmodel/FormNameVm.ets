/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { PresetStyleConstants, StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';

export class FormNameVm {
  @Track public mNameOpacity: number = 1;
  @Track public mNameBackColor: string = StyleConstants.DEFAULT_DESKTOP_BACKGROUND_COLOR;
}

export class FormNameSizeInfo {
  public mFormNameHeight: number = StyleConstants.DEFAULT_APP_NAME_HEIGHT;
  public mFormNameWidth: number = StyleConstants.DEFAULT_APP_ITEM_WIDTH;
  public mFormNameSize: number = StyleConstants.DEFAULT_APP_NAME_SIZE;
  public mNameFontColor: string = '';
  public mNameMargin: number = PresetStyleConstants.DEFAULT_ICON_NAME_GAP;
  public mNameMarginTop: number = PresetStyleConstants.DEFAULT_ICON_NAME_MARGIN_TOP;
}