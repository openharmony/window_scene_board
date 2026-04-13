/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CardItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';

export interface FormStackEventCb {
  // 更新卡片Id回调
  onUpdateId: (card: CardItemInfo, id: string) => void;

  // 更新卡片名称回调
  onUpdateName: (cardId: string, name: string) => void;

  // 删除卡片回调
  onDeleteCardId: (cardId: string, resultType: number, errorMsg?: string) => void;

  // 是否允许改变透明度回调
  onIsAllowChangeOpacity: () => boolean;

  // 清理图片资源回调
  onClearImages: () => void;

  // 卡片onload回调
  onChildFormLoad: (cardId: string) => void;
}