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
import { image } from '@kit.ImageKit';
import { RectInfo } from '@ohos/basicutils';
import { FormStackItemViewData } from '@ohos/launchercommon/Index';
import { GameCardInfo } from '@ohos/launchercommon/src/main/ets/bean/GameCardInfo';

@Observed
export class FormStackAnimateItem extends FormStackItemViewData {
  public idStr: string = '';
  public bundleName: string = '';
  public formId: string = '';
  public snapshot?: image.PixelMap | null = null;
  public gamecardInfo?: GameCardInfo | undefined = undefined;
}

export class OpenFormStackStateInfo {
  public mWidth: number = 0;
  public mHeight: number = 0;
  public mTopItem: FormStackAnimateItem = new FormStackAnimateItem();
  public mDefaultItem: FormStackAnimateItem = new FormStackAnimateItem();
  public position: RectInfo = new RectInfo();
  public mIsOpenByMenu: boolean = false;
  public formStackScale: ScaleOptions = { x: 1, y: 1 };
  public mUseEffectComIds: string[] = [];
}