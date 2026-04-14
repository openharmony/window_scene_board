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
import taskpool from '@ohos.taskpool';
import { dataShare, dataSharePredicates, DataShareResultSet } from '@kit.ArkData';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { DeviceInfoBean } from '../common/DeviceInfoBean';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'SoundDataShareController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 查询对应耳机mac的设备信息
 * @param mac 耳机mac
 * @returns 数据库查询结果集
 */
@Concurrent
async function dataShareQuery(context: Context, mac: string): Promise<DeviceInfoBean | null> {
  // dataShare要访问的文件路径
  const uriShare = 'datashareproxy://com.ohos.audioaccessorymanager/deviceInfo';
  const helper = await dataShare.createDataShareHelper(context, uriShare, { isProxy: true });
  const predicates = new dataSharePredicates.DataSharePredicates();
  predicates.equalTo('DEVICE_MAC', mac);
  const data: DataShareResultSet = await helper.query(uriShare, predicates, ['*']);
  if (data.rowCount <= 0 || !data.goToFirstRow()) {
    data.close();
    helper.close();
    return null;
  }
  const deviceInfo: DeviceInfoBean = new DeviceInfoBean();
  deviceInfo.deviceName = data.getString(data.getColumnIndex('DEVICE_NAME'));
  const encryptSn = data.getString(data.getColumnIndex('ENCRYPT_SN'));
  if (encryptSn.length > 0) {
    deviceInfo.sn = encryptSn;
  } else {
    deviceInfo.sn = data.getString(data.getColumnIndex('SN'));
  }
  deviceInfo.modelId = data.getString(data.getColumnIndex('MODEL_ID'));
  deviceInfo.subModelId = data.getString(data.getColumnIndex('SUB_MODEL_ID'));
  deviceInfo.deviceSoftVersion = data.getString(data.getColumnIndex('DEVICE_SOFT_VERSION'));
  deviceInfo.modifyName = data.getString(data.getColumnIndex('MODIFY_NAME'));
  deviceInfo.deviceBtMac = data.getString(data.getColumnIndex('DEVICE_BT_MAC'));
  deviceInfo.deviceRightSleMac = data.getString(data.getColumnIndex('DEVICE_RIGHT_SLE_MAC'));
  deviceInfo.deviceLeftSleMac = data.getString(data.getColumnIndex('DEVICE_LEFT_SLE_MAC'));
  deviceInfo.deviceMac = mac;
  // 使用完后需销毁
  data.close();
  helper.close();
  return deviceInfo;
}

class SoundDataShareController {
  // 设备信息
  private deviceInfoMap: Map<string, DeviceInfoBean> = new Map();

  /**
   * 销毁设备信息
   */
  public destroy(): void {
    log.showInfo('SoundDataShareController destroy');
    this.deviceInfoMap.clear();
  }

  /**
   * 获取设备信息
   *
   * @param mac 耳机mac
   * @returns 设备信息
   */
  public async queryDeviceInfo(mac: string): Promise<DeviceInfoBean | null> {
    if (mac === '') {
      return null;
    }
    // 已查询过返回缓存的设备信息
    if (this.deviceInfoMap.has(mac)) {
      log.showInfo('queryDeviceInfo deviceInfo exit');
      return this.deviceInfoMap.get(mac) ?? null;
    }
    try {
      // 查询数据库
      // log.showInfo(`queryDeviceInfo ${convertMac(mac)}`)
      const data = await taskpool.execute(dataShareQuery, GlobalContext.getContext(), mac) as DeviceInfoBean | null;
      if (!data) {
        log.showInfo('queryDeviceInfo dataShareQuery is null');
        return null;
      }
      this.deviceInfoMap.set(mac, data);
      return data;
    } catch (e) {
      const error = e as BusinessError;
      log.showError(`queryDeviceInfo error: ${error.code}, ${error.message}`);
      return null;
    }
  }
}

export default new SoundDataShareController();