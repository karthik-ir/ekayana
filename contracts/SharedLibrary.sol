pragma solidity ^0.4.19;

import "./EthMeetDB.sol";
import "./SafeMath.sol";
import "./strings.sol";

library SharedLibrary {
    function getCount(address db, string countKey) internal returns(uint) {
        return EthMeetDB(db).getUIntValue(sha3(countKey));
    }

    function createNext(address db, string countKey) internal returns(uint index) {
        var count = getCount(db, countKey);
        EthMeetDB(db).addUIntValue(sha3(countKey), 1);
        return count + 1;
    }

    function containsValue(address db, uint id, string key, uint8[] array) internal returns(bool) {
        if (array.length == 0) {
            return true;
        }
        var val = EthMeetDB(db).getUInt8Value(sha3(key, id));
        for (uint i = 0; i < array.length ; i++) {
            if (array[i] == val) {
                return true;
            }
        }
        return false;
    }

    function addArrayItem(address db, string key, string countKey, address val) internal {
        var idx = EthMeetDB(db).getUIntValue(sha3(countKey));
        EthMeetDB(db).setAddressValue(sha3(key, idx), val);
        EthMeetDB(db).setUIntValue(sha3(countKey), idx + 1);
    }

    function getAddressArray(address db, string key, string countKey) internal returns(address[] result) {
        var count = EthMeetDB(db).getUIntValue(sha3(countKey));
        result = new address[](count);
        for (uint i = 0; i < count; i++) {
            result[i] = EthMeetDB(db).getAddressValue(sha3(key, i));
        }
        return result;
    }

    function getIdArrayItemsCount(address db, uint id, string countKey) internal returns(uint) {
        return EthMeetDB(db).getUIntValue(sha3(countKey, id));
    }

    function getIdArrayItemsCount(address db, address id, string countKey) internal returns(uint) {
        return EthMeetDB(db).getUIntValue(sha3(countKey, id));
    }

    function addIdArrayItem(address db, uint id, string key, string countKey, uint val) internal {
        var idx = getIdArrayItemsCount(db, id, countKey);
        EthMeetDB(db).setUIntValue(sha3(key, id, idx), val);
        EthMeetDB(db).setUIntValue(sha3(countKey, id), idx + 1);
    }

    function addIdArrayItem(address db, uint id, string key, string countKey, address val) internal {
        var idx = getIdArrayItemsCount(db, id, countKey);
        EthMeetDB(db).setAddressValue(sha3(key, id, idx), val);
        EthMeetDB(db).setUIntValue(sha3(countKey, id), idx + 1);
    }

    function addIdArrayItem(address db, address id, string key, string countKey, uint val) internal {
        var idx = getIdArrayItemsCount(db, id, countKey);
        EthMeetDB(db).setUIntValue(sha3(key, id, idx), val);
        EthMeetDB(db).setUIntValue(sha3(countKey, id), idx + 1);
    }

    function setIdArray(address db, uint id, string key, string countKey, uint[] array) internal {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == 0) throw;
            EthMeetDB(db).setUIntValue(sha3(key, id, i), array[i]);
        }
        EthMeetDB(db).setUIntValue(sha3(countKey, id), array.length);
    }

    function setIdArray(address db, address id, string key, string countKey, uint[] array) internal {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == 0) throw;
            EthMeetDB(db).setUIntValue(sha3(key, id, i), array[i]);
        }
        EthMeetDB(db).setUIntValue(sha3(countKey, id), array.length);
    }

    function getIdArray(address db, uint id, string key, string countKey) internal returns(uint[] result) {
        uint count = getIdArrayItemsCount(db, id, countKey);
        result = new uint[](count);
        for (uint i = 0; i < count; i++) {
            result[i] = EthMeetDB(db).getUIntValue(sha3(key, id, i));
        }
        return result;
    }

    function getIdArray(address db, address id, string key, string countKey) internal returns(uint[] result) {
        uint count = getIdArrayItemsCount(db, id, countKey);
        result = new uint[](count);
        for (uint i = 0; i < count; i++) {
            result[i] = EthMeetDB(db).getUIntValue(sha3(key, id, i));
        }
        return result;
    }

    function setIdArray(address db, uint id, string key, string countKey, address[] array) internal {
        for (uint i = 0; i < array.length; i++) {
            require(array[i] != 0x0);
            EthMeetDB(db).setAddressValue(sha3(key, id, i), array[i]);
        }
        EthMeetDB(db).setUIntValue(sha3(countKey, id), array.length);
    }

    function getAddressIdArray(address db, uint id, string key, string countKey) internal returns(address[] result) {
        uint count = getIdArrayItemsCount(db, id, countKey);
        result = new address[](count);
        for (uint i = 0; i < count; i++) {
            result[i] = EthMeetDB(db).getAddressValue(sha3(key, id, i));
        }
        return result;
    }

    function addRemovableIdArrayItem(address db, uint[] ids, string key, string countKey, string keysKey, uint val) internal {
        if (ids.length == 0) {
            return;
        }
        for (uint i = 0; i < ids.length; i++) {
            if (EthMeetDB(db).getUInt8Value(sha3(key, ids[i], val)) == 0) { // never seen before
                addIdArrayItem(db, ids[i], keysKey, countKey, val);
            }
            EthMeetDB(db).setUInt8Value(sha3(key, ids[i], val), 1); // 1 == active
        }
    }

    function addRemovableIdArrayItem(address db, uint[] ids, string key, string countKey, string keysKey, address val) internal {
        if (ids.length == 0) {
            return;
        }
        for (uint i = 0; i < ids.length; i++) {
            if (EthMeetDB(db).getUInt8Value(sha3(key, ids[i], val)) == 0) { // never seen before
                addIdArrayItem(db, ids[i], keysKey, countKey, val);
            }
            EthMeetDB(db).setUInt8Value(sha3(key, ids[i], val), 1); // 1 == active
        }
    }

    function getRemovableIdArrayItems(address db, uint id, string key, string countKey, string keysKey)
        internal returns (uint[] result)
    {
        var count = getIdArrayItemsCount(db, id, countKey);
        result = new uint[](count);
        uint j = 0;
        for (uint i = 0; i < count; i++) {
            var itemId = EthMeetDB(db).getUIntValue(sha3(keysKey, id, i));
            if (EthMeetDB(db).getUInt8Value(sha3(key, id, itemId)) == 1) { // 1 == active
                result[j] = itemId;
                j++;
            }
        }
        return take(j, result);
    }

    function getRemovableIdArrayAddressItems(address db, uint id, string key, string countKey, string keysKey)
        internal returns (address[] result)
    {
        var count = getIdArrayItemsCount(db, id, countKey);
        result = new address[](count);
        uint j = 0;
        for (uint i = 0; i < count; i++) {
            var itemId = EthMeetDB(db).getAddressValue(sha3(keysKey, id, i));
            if (EthMeetDB(db).getUInt8Value(sha3(key, id, itemId)) == 1) { // 1 == active
                result[j] = itemId;
                j++;
            }
        }
        return take(j, result);
    }

    function removeIdArrayItem(address db, uint[] ids, string key, uint val) internal {
        if (ids.length == 0) {
            return;
        }
        for (uint i = 0; i < ids.length; i++) {
            EthMeetDB(db).setUInt8Value(sha3(key, ids[i], val), 2); // 2 == blocked
        }
    }

    function removeIdArrayItem(address db, uint[] ids, string key, address val) internal {
        if (ids.length == 0) {
            return;
        }
        for (uint i = 0; i < ids.length; i++) {
            EthMeetDB(db).setUInt8Value(sha3(key, ids[i], val), 2); // 2 == blocked
        }
    }

    function getPage(uint[] array, uint offset, uint limit, bool cycle) internal returns (uint[] result) {
        uint j = 0;
        uint length = array.length;
        if (offset >= length || limit == 0) {
            return result;
        }

        result = new uint[](limit);
        for (uint i = offset; i < (offset + limit); i++) {
            if (length == i) {
                break;
            }
            result[j] = array[i];
            j++;
        }

        if (cycle && j < limit) {
            var k = limit - j;
            for (i = 0; i <= k; i++) {
                if (limit == j) {
                    break;
                }
                result[j] = array[i];
                j++;
            }
        }
        return take(j, result);
    }

    function getPage(address[] array, uint offset, uint limit, bool cycle) internal returns (address[] result) {
        uint j = 0;
        uint length = array.length;
        if (offset >= length || limit == 0) {
            return result;
        }

        result = new address[](limit);
        for (uint i = offset; i < (offset + limit); i++) {
            if (length == i) {
                break;
            }
            result[j] = array[i];
            j++;
        }

        if (cycle && j < limit) {
            var k = limit - j;
            for (i = 0; i <= k; i++) {
                if (limit == j) {
                    break;
                }
                result[j] = array[i];
                j++;
            }
        }
        return take(j, result);
    }

    /* Assumes sorted a & b */
    function intersect(uint[] a, uint[] b) internal returns(uint[] c) {
        uint aLen = a.length;
        uint bLen = b.length;
        if (aLen == 0 || bLen == 0) {
            return c;
        }
        c = new uint[](aLen);
        uint i = 0;
        uint j = 0;
        uint k = 0;
        while (i < aLen && j < bLen) {
            if (a[i] > b[j]) {
                j++;
            } else if (a[i] < b[j]) {
                i++;
            } else {
                c[k] = a[i];
                i++;
                j++;
                k++;
            }
        }
        return take(k, c);
    }

    /* Assumes sorted a & b */
    function intersect(address[] a, address[] b) internal returns(address[] c) {
        uint aLen = a.length;
        uint bLen = b.length;
        if (aLen == 0 || bLen == 0) {
            return c;
        }
        c = new address[](aLen);
        uint i = 0;
        uint j = 0;
        uint k = 0;
        while (i < aLen && j < bLen) {
            if (a[i] > b[j]) {
                j++;
            } else if (a[i] < b[j]) {
                i++;
            } else {
                c[k] = a[i];
                i++;
                j++;
                k++;
            }
        }
        return take(k, c);
    }

    /* Assumes sorted a & b */
    function union(uint[] a, uint[] b) internal returns(uint[] c) {
        uint aLen = a.length;
        uint bLen = b.length;
        c = new uint[](aLen + bLen);
        uint i = 0;
        uint j = 0;
        uint k = 0;
        while (i < aLen && j < bLen) {
            if (a[i] < b[j]) {
                c[k] = a[i];
                i++;
            } else if (b[j] < a[i]) {
                c[k] = b[j];
                j++;
            } else {
                c[k] = a[i];
                i++;
                j++;
            }
            k++;
        }

        while (i < aLen) {
            c[k] = a[i];
            i++;
            k++;
        }

        while (j < bLen) {
            c[k] = b[j];
            j++;
            k++;
        }

        return take(k, c);
    }

    /* Assumes sorted a & b */
    function union(address[] a, address[] b) internal returns(address[] c) {
        uint aLen = a.length;
        uint bLen = b.length;
        c = new address[](aLen + bLen);
        uint i = 0;
        uint j = 0;
        uint k = 0;
        while (i < aLen && j < bLen) {
            if (a[i] < b[j]) {
                c[k] = a[i];
                i++;
            } else if (b[j] < a[i]) {
                c[k] = b[j];
                j++;
            } else {
                c[k] = a[i];
                i++;
                j++;
            }
            k++;
        }

        while (i < aLen) {
            c[k] = a[i];
            i++;
            k++;
        }

        while (j < bLen) {
            c[k] = b[j];
            j++;
            k++;
        }

        return take(k, c);
    }
    
    function diff(uint[] _old, uint[] _new) internal returns(uint[] added, uint[] removed) {
        if (_old.length == 0 && _new.length == 0) {
            return (added, removed);
        }
        var maxCount = _old.length + _new.length;
        added = new uint[](maxCount);
        removed = new uint[](maxCount);
        
        _old = sort(_old);
        _new = sort(_new);
        uint ol_i = 0;
        uint ne_i = 0;
        uint ad_i = 0;
        uint re_i = 0;
        while (ol_i < _old.length && ne_i < _new.length) {
            if (_old[ol_i] > _new[ne_i]) {
                added[ad_i] = _new[ne_i];
                ne_i++;
                ad_i++;
            } else if (_old[ol_i] < _new[ne_i]) {
                removed[re_i] = _old[ol_i];
                ol_i++;
                re_i++;
            } else {
                ol_i++;
                ne_i++;
            }
        }
        if (_old.length > ol_i) {
            while (ol_i < _old.length) {
                removed[re_i] = _old[ol_i];
                ol_i++;
                re_i++;
            }
        }
        if (_new.length > ne_i) {
            while (ne_i < _new.length) {
                added[ad_i] = _new[ne_i];
                ne_i++;
                ad_i++;
            }
        }
        return (take(ad_i, added), take(re_i, removed));
    }    

    function sort(uint[] array) internal returns (uint[]) {
        for (uint i = 1; i < array.length; i++) {
            var t = array[i];
            var j = i;
            while(j > 0 && array[j - 1] > t) {
                array[j] = array[j - 1];
                j--;
            }
            array[j] = t;
        }
        return array;
    }

    function sort(address[] array) internal returns (address[]) {
        for (uint i = 1; i < array.length; i++) {
            var t = array[i];
            var j = i;
            while(j > 0 && array[j - 1] > t) {
                array[j] = array[j - 1];
                j--;
            }
            array[j] = t;
        }
        return array;
    }

    function sortDescBy(uint[] array, uint[] compareArray) internal returns (uint[]) {
        for (uint i = 1; i < array.length; i++) {
            var t = array[i];
            var t2 = compareArray[i];
            var j = i;
            while(j > 0 && compareArray[j - 1] < t2) {
                array[j] = array[j - 1];
                compareArray[j] = compareArray[j - 1];
                j--;
            }
            array[j] = t;
            compareArray[j] = t2;
        }
        return array;
    }


    function take(uint n, uint[] array) internal returns(uint[] result) {
        if (n > array.length) {
            return array;
        }
        result = new uint[](n);
        for (uint i = 0; i < n ; i++) {
            result[i] = array[i];
        }
        return result;
    }

    function take(uint n, bytes32[] array) internal returns(bytes32[] result) {
        if (n > array.length) {
            return array;
        }
        result = new bytes32[](n);
        for (uint i = 0; i < n ; i++) {
            result[i] = array[i];
        }
        return result;
    }

    function take(uint n, address[] array) internal returns(address[] result) {
        if (n > array.length) {
            return array;
        }
        result = new address[](n);
        for (uint i = 0; i < n ; i++) {
            result[i] = array[i];
        }
        return result;
    }

    function findTopNValues(uint[] values, uint n) internal returns(uint[]) {
        uint length = values.length;

        for (uint i = 0; i <= n; i++) {
            uint maxPos = i;
            for (uint j = i + 1; j < length; j++) {
                if (values[j] > values[maxPos]) {
                    maxPos = j;
                }
            }

            if (maxPos != i) {
                uint maxValue = values[maxPos];
                values[maxPos] = values[i];
                values[i] = maxValue;
            }
        }
        return take(n, values);
    }

    function filter(
        address db,
        function (address, uint[] memory, uint) returns (bool) f,
        uint[] memory items,
        uint[] memory args
    )
        internal returns (uint[] memory r)
    {
        uint j = 0;
        r = new uint[](items.length);
        for (uint i = 0; i < items.length; i++) {
            if (f(db, args, items[i])) {
                r[j] = items[i];
                j++;
            }
        }
        return take(j, r);
    }

    function filter(
        address db,
        function (address, address[] memory, uint) returns (bool) f,
        uint[] memory items,
        address[] memory args
    )
        internal returns (uint[] memory r)
    {
        uint j = 0;
        r = new uint[](items.length);
        for (uint i = 0; i < items.length; i++) {
            if (f(db, args, items[i])) {
                r[j] = items[i];
                j++;
            }
        }
        return take(j, r);
    }

    function filter(
        address db,
        function (address, uint[] memory, uint[] memory, uint) returns (bool) f,
        uint[] memory items,
        uint[] memory args,
        uint[] memory args2
    )
        internal returns (uint[] memory r)
    {
        uint j = 0;
        r = new uint[](items.length);
        for (uint i = 0; i < items.length; i++) {
            if (f(db, args, args2, items[i])) {
                r[j] = items[i];
                j++;
            }
        }
        return take(j, r);
    }

    function contains(address[] array, address val) internal returns(bool) {
        for (uint i = 0; i < array.length ; i++) {
            if (array[i] == val) {
                return true;
            }
        }
        return false;
    }

    function contains(uint[] array, uint val) internal returns(bool) {
        for (uint i = 0; i < array.length ; i++) {
            if (array[i] == val) {
                return true;
            }
        }
        return false;
    }

}