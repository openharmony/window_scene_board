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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import {
  PasswordComplexityUtil
} from '@ohos/pcbase/src/main/ets/SceneBoard/screenlock/common/PasswordComplexityUtil';

export default function PasswordComplexityUtilTest() {
  describe('PasswordComplexityUtilTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    /*
    * @tc.number:PasswordComplexityUtil
    * @tc.name: 将字符串转码为 Uint8Array
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 将字符串转码为 Uint8Array
    */
    it('passwordComplexityUtil_01', 0, passwordComplexityUtil_01);

    /*
    * @tc.number:PasswordComplexityUtil
    * @tc.name: 同步方式任意数量string类型替换
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 同步方式任意数量string类型替换
    */
    it('passwordComplexityUtil_02', 0, passwordComplexityUtil_02);

    /*
    * @tc.number:PasswordComplexityUtil
    * @tc.name: 获取密码复杂度
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 获取密码复杂度
    */
    it('passwordComplexityUtil_03', 0, passwordComplexityUtil_03);

    /*
    * @tc.number:PasswordComplexityUtil
    * @tc.name: 以同步方式获取string资源值 字串为空时
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 以同步方式获取string资源值 字串为空时
    */
    it('passwordComplexityUtil_04', 0, passwordComplexityUtil_04);

    /*
    * @tc.number:PasswordComplexityUtil
    * @tc.name: 以同步方式获取string资源值 输入普通字串
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 以同步方式获取string资源值 输入普通字串
    */
    it('passwordComplexityUtil_05', 0, passwordComplexityUtil_05);

    /*
    * @tc.number:PasswordComplexityUtil
    * @tc.name: 将字符串转码为 Uint8Array 字串为空
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 将字符串转码为 Uint8Array 字串为空
    */
    it('passwordComplexityUtil_06', 0, passwordComplexityUtil_06);

    /*
    * @tc.number:PasswordComplexityUtil
    * @tc.name: 将字符串转码为 Uint8Array 输入普通字串
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 将字符串转码为 Uint8Array 输入普通字串
    */
    it('passwordComplexityUtil_07', 0, passwordComplexityUtil_07);

    /*
    * @tc.number:PasswordComplexityUtil
    * @tc.name: 判断密码是否包含非法字符，不在下面合法字符范围内的字符均是非法字符 输入普通字符
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 判断密码是否包含非法字符，不在下面合法字符范围内的字符均是非法字符 输入普通字符
    */
    it('passwordComplexityUtil_08', 0, passwordComplexityUtil_08);

    /*
    * @tc.number:PasswordComplexityUtil
    * @tc.name: 判断密码是否包含非法字符，不在下面合法字符范围内的字符均是非法字符 输入非法字符
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 判断密码是否包含非法字符，不在下面合法字符范围内的字符均是非法字符 输入非法字符
    */
    it('passwordComplexityUtil_09', 0, passwordComplexityUtil_09);

    /*
    * @tc.number:PasswordComplexityUtil
    * @tc.name: 判断密码是否包含非法字符，不在下面合法字符范围内的字符均是非法字符 字符为空
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 判断密码是否包含非法字符，不在下面合法字符范围内的字符均是非法字符 字符为空
    */
    it('passwordComplexityUtil_10', 0, passwordComplexityUtil_10);

  })
}


/**
 * PasswordComplexityUtil：将字符串转码为 Uint8Array
 */
function passwordComplexityUtil_01() {
  try {
    PasswordComplexityUtil.stringToUint8Array('');
  } catch (e) {
    expect(false).assertTrue();
  }
}

/**
 * PasswordComplexityUtil：同步方式任意数量string类型替换
 */
function passwordComplexityUtil_02() {
  try {
    PasswordComplexityUtil
      .getAnyNumFormatStringSync($r('app.string.The_password_consists_of_6_32_characters'), 6
        , 32);
  } catch (e) {
    expect(false).assertTrue();
  }
}

/**
 * PasswordComplexityUtil：获取密码复杂度
 */
function passwordComplexityUtil_03() {
  try {
    PasswordComplexityUtil.getPasswordPolicy();
  } catch (e) {
    expect(false).assertTrue();
  }
}

/**
 * PasswordComplexityUtil：以同步方式获取string资源值 字串为空时
 */
function passwordComplexityUtil_04() {
  try {
    PasswordComplexityUtil.getStringSync('')
  } catch (e) {
    expect(false).assertTrue();
  }
}

/**
 * PasswordComplexityUtil：以同步方式获取string资源值 输入普通字串
 */
function passwordComplexityUtil_05() {
  try {
    PasswordComplexityUtil.getStringSync('string')
  } catch (e) {
    expect(false).assertTrue();
  }
}

/**
 * PasswordComplexityUtil：将字符串转码为 Uint8Array 字串为空
 */
function passwordComplexityUtil_06() {
  try {
    PasswordComplexityUtil.stringToUint8Array('')
  } catch (e) {
    expect(false).assertTrue();
  }
}

/**
 * PasswordComplexityUtil：将字符串转码为 Uint8Array 输入普通字串
 */
function passwordComplexityUtil_07() {
  try {
    PasswordComplexityUtil.stringToUint8Array('string')
  } catch (e) {
    expect(false).assertTrue();
  }
}

/**
 * PasswordComplexityUtil：判断密码是否包含非法字符，不在下面合法字符范围内的字符均是非法字符 输入普通字符
 */
function passwordComplexityUtil_08() {
  try {
    PasswordComplexityUtil.isContainIllegalCharacter('1')
  } catch (e) {
    expect(false).assertTrue();
  }
}

/**
 * PasswordComplexityUtil：判断密码是否包含非法字符，不在下面合法字符范围内的字符均是非法字符 输入非法字符
 */
function passwordComplexityUtil_09() {
  try {
    PasswordComplexityUtil.isContainIllegalCharacter('~')
  } catch (e) {
    expect(false).assertTrue();
  }
}

/**
 * PasswordComplexityUtil：判断密码是否包含非法字符，不在下面合法字符范围内的字符均是非法字符 字符为空
 */
function passwordComplexityUtil_10() {
  try {
    PasswordComplexityUtil.isContainIllegalCharacter('')
  } catch (e) {
    expect(false).assertTrue();
  }
}

