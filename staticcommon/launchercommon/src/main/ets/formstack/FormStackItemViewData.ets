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

@Observed
export class FormStackItemViewData {
  public mTranslateY: number = 0;

  public mScaleX: number = 1;

  public mScaleY: number = 1;

  public mRotateAngle: number = 0;

  public mOpacity: number = 1;

  public mBorderRadius: number = 1;

  public mIsOffsetY: boolean = false;

  public zIndex: number = 0;

  public mVisible: boolean = true;

  public mClickable: boolean = true;

  public mIsSupportShadow: boolean = false;

  public mWidth: number = 0;

  public mHeight: number = 0;

  public mUseEffect: boolean = false;

  public mIsAppExiting: boolean = false;
}