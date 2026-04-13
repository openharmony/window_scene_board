/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

/**
 * Constants of events that will be registered to system.
 */
export const enum FormConstants {
  // publish form action
  ACTION_PUBLISH_FORM = 'action.form.publish',

  // open form related page
  ACTION_FORM_PAGE = 'action.form.page',

  FORM_ID_PARAM = 'ohos.extra.param.key.live_form_id',
  JSON_WANT_PARAM = 'ohos.extra.param.key.json_want',
  // publish card parameters
  ID_PARAM = 'ohos.extra.param.key.form_identity',
  FORM_ID = 'formID',
  NAME_PARAM = 'ohos.extra.param.key.form_name',
  BUNDLE_PARAM = 'ohos.extra.param.key.bundle_name',
  ABILITY_PARAM = 'ohos.extra.param.key.ability_name',
  MODULE_PARAM = 'ohos.extra.param.key.module_name',
  DIMENSION_PARAM = 'ohos.extra.param.key.form_dimension',
  TEMPORARY_PARAM = 'ohos.extra.param.key.form_temporary',
  CALLER_BUNDLE_PARAM = 'ohos.extra.param.key.caller_bundle_name',
  FORM_INFO_LIST = 'ohos.extra.param.key.target_form_info_list',
  TARGET_FORM_LABEL = 'ohos.extra.param.key.target_form_label',
  TARGET_FORM_DESCRIPTION = 'ohos.extra.param.key.target_form_description',
  TARGET_FORM_DIMENSION = 'ohos.extra.param.key.target_form_dimension',
  TARGET_FORM_DATA = 'ohos.extra.param.key.target_form_data',

  // app publish card extra parameters
  APP_FORM_SNAPSHOT = 'ohos.extra.param.key.add_form_to_host_snapshot',
  APP_FORM_WIDTH = 'ohos.extra.param.key.add_form_to_host_width',
  APP_FORM_HEIGHT = 'ohos.extra.param.key.add_form_to_host_height',
  APP_FORM_SCREEN_X = 'ohos.extra.param.key.add_form_to_host_screenx',
  APP_FORM_SCREEN_Y = 'ohos.extra.param.key.add_form_to_host_screeny',

  RECOVERY_PARAM = 'ohos.app.recovery',
  LOGOUT_RECOVERY_PARAM = 'ohos.app.logout_recovery',

  BUNDLE_LITE_GAMES = 'com.ohos.litegames',
  BIND_GAME_STACKING_BOXES = 'com.openharmony.StackingBoxes',
};