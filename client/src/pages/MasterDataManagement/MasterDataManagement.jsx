import checkPermission from '~/utils/checkPermission';
function MasterDataManagement() {


  return (
    <div>
      {
        checkPermission('2') ? (
          <div>
            <h2>Master Data Management</h2>
          </div>
        ) : (
          <div>
            <h2>No permissions</h2>
          </div>
        )

      }
    </div>
  );
}

export default MasterDataManagement;