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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/utils/GlobalContext';
import { dataShare, dataSharePredicates, DataShareResultSet } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { image } from '@kit.ImageKit';

const TAG: string = 'ImageDownloaderUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);
const HISTORY_URL = 'datashare:///com.ohos.mediacontroller/datashare_history'

export default class ImageDownloaderUtils {
  public static mediaImage: string | image.PixelMap = '';
  public static async downloadImage(url: string): Promise<string> {
    let result: DataShareResultSet | undefined = undefined;
    let dataShareHelper: dataShare.DataShareHelper | undefined = undefined;
    try {
      let context = GlobalContext.getInstance().getObject('desktopContext') as common.ServiceExtensionContext;
      dataShareHelper = await dataShare.createDataShareHelper(context, HISTORY_URL);
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo('URL', url);
      result = await dataShareHelper.query(HISTORY_URL, predicates, [url]);
      if (!result) {
        log.error(`downloadImage result is null,error: ${JSON.stringify(result)}`);
      } else {
        log.debug('downloadImage succeed, rowCount : ' + result.rowCount);
        if (result.rowCount > 0 && result.goToFirstRow()) {
          let img: string = result.getString(result.getColumnIndex('IMAGE'));
          log.debug(`downloadImage succeed, img : ${img}`);
          result.close();
          dataShareHelper?.close();
          return img;
        } else {
          log.error(`downloadImage data.rowCount <= 0, rowCount : ${result.rowCount}`);
        }
      }
    } catch (e) {
      log.showError(`downloadImage error:${JSON.stringify(e)}`);
    }
    result?.close();
    return '';
  }
}