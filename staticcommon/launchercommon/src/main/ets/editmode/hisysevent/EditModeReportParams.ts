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

export class EnterEditModeParams {
  public PNAMEID: string = '';
  public PVERSIONID: string = '';
  public ENTER_TYPE: number = 0;
  public SCREEN_TYPE: number = 0;
}

export class ExitEditModeParams {
  public PNAMEID?: string;
  public PVERSIONID?: string;
  public EXIT_TYPE?: number;
  public ISCHANGED: boolean = false;
  public DURATION: string = '';
  public SCREEN_TYPE?: number;
}

export class EditModeUninstallParams {
  public PNAMEID?: string;
  public PVERSIONID?: string;
  public TYPE: number = 0;
  public APP_TYPE: string = '';
  public APP_INFO: string = '';
  public SCREEN_TYPE?: number;
}

export class EditModeRemoveParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  SCREEN_TYPE?: number;
  TYPE: number;
  APP_INFO: string;
}

export class EditModeUninstallDialogParams {
  public PNAMEID?: string;
  public PVERSIONID?: string;
  public SCREEN_TYPE?: number;
  public TYPE: number = 0;
  public APP_INFO: string = '';
  public NOT_UNINSTALLABLE_INFO: string = '';
}

export class EditModeHomePageSettingParams {
  public PNAMEID?: string;
  public PVERSIONID?: string;
  public SCREEN_TYPE?: number;
  public TYPE: number = 0;
}

export class AddOuterAppByClick {
  public PNAMEID: string = '';
  public PVERSIONID: string = '';
  public PACKAGENAME: string = '';
  public APPID: string = '';
  public APPNAME: string = '';
  public CELLX: number = 0;
  public CELLY: number = 0;
  public SCREENID: number = 0;
  public SCREEN_TYPE: number = 0;
}

export class AddOuterAppByDrag {
  public PNAMEID: string = '';
  public PVERSIONID: string = '';
  public PACKAGENAME: string = '';
  public APPID: number = 0;
  public APPNAME: string = '';
  public CELLX: number = 0;
  public CELLY: number = 0;
  public SCREENID: number = 0;
  public SCREEN_TYPE: number = 0;
}

export class ShortcutParams {
  public PNAMEID: string = '';
  public PVERSIONID: string = '';
  public SHORTCUTID: string = '';
  public COMPONENT: string = '';
  public MODULENAME: string = '';
  public SCREEN_TYPE: number = 0;
}

export class ApplyIconEditParams {
  public PNAMEID: string = '';
  public PVERSIONID: string = '';
  public ICONSIZE: number = 0;
  public IS_NAME_SHOW: boolean = false;
}

export class EnterSubPageParams {
  public PNAMEID: string = '';
  public PVERSIONID: string = '';
  public PAGETITLE: string = '';
}

export class BaseParams {
  public PNAMEID: string = '';
  public PVERSIONID: string = '';
}